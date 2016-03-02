unit DiamantiMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, System.IOUtils,
  (* MongoWire *) mongoWire, bsonDoc, mongoStream, mongoID, mongoAuth3,
  DiamantiUtils;

type
  TFDiamanti = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    btnAdd: TButton;
    btnGet: TButton;
    btnDelete: TButton;
    ListView1: TListView;
    btnConnect: TButton;
    LabelConexao: TLabel;
    LabelQuantidade: TLabel;
    btnDisconnect: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AtualizarStatus;
  private
    q: TMongoWireQuery;
    d: IBSONDocument;
    m: TMongoStream;
    li: TListItem;
  end;

type
  TConnMongoDB = class
    strict private class var AMongoWire: TMongoWire;
    strict private class function GetConnection(ANamespace: String; AServer: String; APort: Integer): TMongoWire;
    public class procedure CreateConnection();
    public class procedure CloseConnection();
    public class function GetCurrentConnection(): TMongoWire;
    public class function ExistsConnection(): Boolean;
  end;


var
  FDiamanti: TFDiamanti;

implementation

{$R *.dfm}

const
  NameSpace  = 'diamanti';
  Collection = 'stored';
  Server     = 'ds019678.mlab.com';
  Port       = 19678;
  User       = 'user';
  Password   = 'user';
  siID       = 1;

{ TConnMongoDB }

class procedure TConnMongoDB.CloseConnection;
begin
  if ( AMongoWire <> nil ) then
    FreeAndNil( AMongoWire );
end;

class procedure TConnMongoDB.CreateConnection;
begin
  AMongoWire := GetConnection(Namespace, Server, Port);
end;

class function TConnMongoDB.ExistsConnection: Boolean;
begin
  Result:= ( GetCurrentConnection <> nil );
end;

class function TConnMongoDB.GetConnection(ANamespace: String; AServer: String; APort: Integer): TMongoWire;
begin
  if ( ExistsConnection() ) then
    GetCurrentConnection().Close();

  Result := TMongoWire.Create(ANamespace);
  Result.Open( AServer, APort );
end;

class function TConnMongoDB.GetCurrentConnection: TMongoWire;
begin
  Result := AMongoWire;
end;


procedure TFDiamanti.AtualizarStatus;
begin
   if TConnMongoDB.ExistsConnection then
      LabelConexao.Caption := 'Status da Conexão: Ativada'
   else LabelConexao.Caption := 'Status da Conexão: Desativada';

   LabelQuantidade.Caption := Format('Quantidade de arquivos XML guardados: %s ', [IntToStr(ListView1.Items.Count)]);
end;


{ TDiamanti }

procedure TFDiamanti.btnConnectClick(Sender: TObject);
begin
   try
      if TConnMongoDB.ExistsConnection then
      begin
         TConnMongoDB.CloseConnection();
         ListView1.Items.Clear;
         AtualizarStatus;
      end;

      TConnMongoDB.CreateConnection();
      MongoWireAuthenticate(TConnMongoDB.GetCurrentConnection, User, Password);

      q := TMongoWireQuery.Create(TConnMongoDB.GetCurrentConnection);
      q.Query(Collection+mongoStreamFilesSuffix,BSON);

      ListView1.Items.BeginUpdate;
      try
         d := BSON;
         while q.Next(d) do
         begin
            li := ListView1.Items.Add;
            li.Caption := VarToStr(d['chaveacesso']);
            li.SubItems.Add(VarToStr(d['contentxml']));
            li.SubItems.Add(VarToStr(d['_id']));
         end;
      finally
         ListView1.Items.EndUpdate;
         AtualizarStatus;
      end;

   except on E: Exception do
      begin
         ShowMessage(Format('Error: %s', [E.Message]));
      end;
   end;
end;

procedure TFDiamanti.btnDisconnectClick(Sender: TObject);
begin
   try
      if TConnMongoDB.ExistsConnection then
      begin
         TConnMongoDB.CloseConnection();
         ListView1.Items.Clear;
      end;
      AtualizarStatus;

   except on E: Exception do
      begin
         ShowMessage(Format('Error: %s', [E.Message]));
      end;
   end;
end;

procedure TFDiamanti.btnAddClick(Sender: TObject);
var id: OleVariant;
    f: TFileStream;
    path_chaveacesso, chaveacesso, contentxml:string;
begin

   if OpenDialog1.Execute then
   begin
      path_chaveacesso := OpenDialog1.FileName;
      contentxml := TFile.ReadAllText(path_chaveacesso);
      chaveacesso := DiamantiUtils.OnlyNumber(ExtractFileName(path_chaveacesso));

      // Busca chave de acesso para não duplicar
      q := TMongoWireQuery.Create(TConnMongoDB.GetCurrentConnection);
      q.Query(Collection+mongoStreamFilesSuffix,BSON);
      d := BSON;
      while q.Next(d) do
      begin
         if chaveacesso = VarToStr(d['chaveacesso']) then
            Exit;
      end;

      // Faz a inserção
      f := TFileStream.Create(path_chaveacesso,fmOpenRead or fmShareDenyWrite);
      try
         id := TMongoStream.Add(TConnMongoDB.GetCurrentConnection,Collection,f,BSON([
                  'chaveacesso', chaveacesso,
                  'contentxml', contentxml,
                  'criacao', VarFromDateTime(Now)
         ]));

         li := ListView1.Items.Add;
         li.Caption := chaveacesso;
         li.SubItems.Add(contentxml);
         li.SubItems.Add(VarToStr(id));
      finally
         f.Free;
         AtualizarStatus;
      end;
   end;
end;

procedure TFDiamanti.btnGetClick(Sender: TObject);
begin
   li := ListView1.Selected;
   if Assigned(li) then
   begin
      SaveDialog1.FileName := li.Caption + '-nfe.xml';
      if SaveDialog1.Execute then
      begin
         m := TMongoStream.Create(TConnMongoDB.GetCurrentConnection,Collection,li.SubItems[siID]);
         try
            m.SaveToFile(SaveDialog1.FileName);
         finally
            m.Free;
         end;
      end;
   end;
end;

procedure TFDiamanti.btnDeleteClick(Sender: TObject);
begin
   try
      li := ListView1.Selected;
      if Assigned(li) then
      begin
         if MessageBox(Handle,PChar('Confirme se deseja realmente apagar "'+li.Caption+'"?'),
           'Diamanti',MB_OKCANCEL or MB_ICONQUESTION)=idOK then
         begin
            TConnMongoDB.GetCurrentConnection.Delete(Collection+mongoStreamFilesSuffix, BSON([mongoStreamIDField,li.SubItems[siID]]));
            TConnMongoDB.GetCurrentConnection.Delete(Collection+mongoStreamChunksSuffix, BSON([mongoStreamFilesIDField,li.SubItems[siID]]));
            li.Delete;
         end;
      end;
   finally
      AtualizarStatus;
   end;
end;

procedure TFDiamanti.FormDestroy(Sender: TObject);
begin
   if not(Assigned(d)) then
      FreeAndNil(d);
   if not(Assigned(q)) then
      FreeAndNil(q);
end;

initialization

finalization
   TConnMongoDB.CloseConnection();
end.
