program Diamanti;

uses
  Forms,
  DiamantiMain in 'DiamantiMain.pas' {FDiamanti},
  simpleSock in 'TMongoWire\simpleSock.pas',
  bsonDoc in 'TMongoWire\bsonDoc.pas',
  mongoID in 'TMongoWire\mongoID.pas',
  mongoStream in 'TMongoWire\mongoStream.pas',
  mongoWire in 'TMongoWire\mongoWire.pas' {/mongoAuth3 in '..\TMongoWire\mongoAuth3.pas';},
  mongoAuth3 in 'TMongoWire\mongoAuth3.pas',
  DiamantiUtils in 'DiamantiUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Diamanti';
  Application.CreateForm(TFDiamanti, FDiamanti);
  Application.Run;
end.
