//Unit en charge des monstres
unit unitMonstre;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
//----- TYPES -----
type
  TypeMonstre = (Jagras,Pukei);                 //Type de monstres
  TMonstre = record                             //Monstre
    typeM : TypeMonstre;                        //type de monstre
    pv : integer;                               //points de vie
    stun : integer;                             //Nombre de tour stun
    prime : integer;
  end;

  TCatalogueMonstre = array[0..ord(high(TypeMonstre))] of TMonstre;

//----- FONCTIONS ET PROCEDURES -----   
//Initialisation des monstres
procedure initialisationMonstres();  
//Renvoie le nom du monstre
function nomMonstre(monstre : TypeMonstre) : string;
//Renvoie une copie du monstre
function getMonstre(i : integer) : TMonstre;


implementation
var
  monstres : TCatalogueMonstre;              //Catalogue des monstres

//Initialisation des monstres
procedure initialisationMonstres();
begin
  monstres[0].typeM:=Jagras;
  monstres[0].pv:=100;
  monstres[0].stun:=0;
  monstres[0].prime := 200;
  monstres[1].typeM:=Pukei;
  monstres[1].pv:=200;
  monstres[1].stun:=0;     
  monstres[1].prime := 500;
end;

//Renvoie le nom du monstre
function nomMonstre(monstre : TypeMonstre) : string;
begin
  case monstre of
       Jagras : nomMonstre:='Grand Jagras';
       Pukei : nomMonstre:='Pukei-Pukei';
  end;
end;

//Renvoie une copie du monstre
function getMonstre(i : integer) : TMonstre;
begin
     getMonstre:=monstres[i];
end;

end.

