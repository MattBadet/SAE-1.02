//Unit en charge de la cantine
unit unitCantine;
{$codepage utf8}
{$mode objfpc}{$H+}

interface

//----- FONCTIONS ET PROCEDURES -----
uses
  unitLieu;

type strarray = array[1..2] of string;

//Fonction exécutée à l'arrivée dans la cantine
//Renvoie le prochain lieu à visiter
function cantineHUB() : typeLieu;












implementation
uses
  sysutils,unitPersonnage,unitIHM,GestionEcran;

//Mange le plat et applique le bonus
procedure manger(nbPlat : integer);
begin
     //Fixe le buff
     setBuff(bonus(nbPlat));
end;

function split(chaine,char:string):strarray;//type strarray = array[1..2] of string;
var i:integer;
 res:array[1..2] of string;
 verif:boolean;
begin
  res[1]:='';
  res[2]:='';
  verif:=false;
  for i:=1 to length(chaine) do
  begin
       if verif then
          res[2]:=res[2]+chaine[i]
       else
       if chaine[i] = char then
          verif:=true
       else
           res[1]:=res[1]+chaine[i]
  end;
  result:=res;
end;

function recupRecette(n : integer): strarray;
var
 FileVar:TextFile;
 str : string;
 tablcrit:array[1..1712] of string;  //RecettesCritique
 tablregen:array[1..1633] of string; //RecettesRegen
 tablforc:array[1..1655] of string;  //RecettesForce
 i,y,j:integer;
begin
  i:=0;
  y:=0;
  j:=0;
  AssignFile(FileVar,'Recettes.txt');
  Reset(FileVar);
  repeat
    Readln(FileVar,str);
    if (Split(Str,'/')[2] = '(Critique)') then
    begin
       i := i+1;
       tablcrit[i]:=Split(Str,'/')[1];
    end;
    if (Split(Str,'/')[2] = '(Regeneration)') then
    begin
         y := y+1;
         tablregen[y]:=Split(Str,'/')[1];
    end;
    if (Split(Str,'/')[2] = '(Force)') then
    begin
         j := j+1;
         tablforc[j]:=Split(Str,'/')[1];
    end;
  until(EOF(FileVar)); // EOF(Fin de fichier) le programme continue à lire des nouvelles jusqu'à la fin
    CloseFile(FileVar);

  case n of
  1:recupRecette := tablforc;
  2:recupRecette := tablregen;
  3:recupRecette := tablcrit;
  end;
end;

//Fonction exécutée pour afficher l'écran d'affichage des recettes
//Renvoie le prochain lieu à visiter
function choixPage(n : integer) : typeLieu;
var choix : string;
  recette : strarray;
  nRecette : integer;
  page : integer;
  i : integer;
  choixNumber : integer;
begin
  page := 1;
  recette := recupRecette(n);

  choix := '';
  while (choix <> '0') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Cantine de la ville de Brightwood');
                                                        
    deplacerCurseurXY(63,5);write('Le cuisinier vous proposent :');
    for i:=1 to 20 do
    deplacerCurseurXY(40,i+6);write(' ', i,'/ ');write(recette[i]);

    dessinerCadreXY(1,27,21,29,simple,white,black);
    deplacerCurseurXY(2,28);write('Buff : ');
    case n of
    1:write('Force');
    2:write('Régénération');
    3:write('Critique');
    end;
    dessinerCadreXY(130,27,147,29,simple,white,black);
    deplacerCurseurXY(131,28);write('Page : 255 / 255');

    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Passer ordre alphabétique à inverse');
    deplacerCurseurZoneAction(5);write('     2/ Choisir une page par numéro');
    deplacerCurseurZoneAction(7);write('     3/ Page précédente');
    deplacerCurseurXY(55,33);write('     4/ Page suivante');
    deplacerCurseurXY(55,35);write('     5/ Choisir plat sur la page');
    deplacerCurseurXY(55,37);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);

    //Si l'utilisateur saisit 0 => sortir
    if(choix = '0') then choixPage := ville
    //Si l'utilisateur saisit un nombre, convertir choix (string) en choixNumber (integer)
    //else EntrerPage();
  end;


end;

//Fonction exécutée à l'arrivée dans la cantine
//Renvoie le prochain lieu à visiter
function cantineHUB() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '0') and (choix <> '1') and (choix <> '2') and (choix <> '3') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Cantine de la ville de Brightwood');

    deplacerCurseurXY(30,7);write('Alors que vous approchez de la cantine, l''air s''emplit d''un épais fumet. Viandes, poissons,');
    deplacerCurseurXY(30,8);write('fruits et légumes dont certains vous sont inconnus sont exposés sur les nombreuses tables');
    deplacerCurseurXY(30,9);write('qui entourent une cuisine de fortune où des palicos s''affairent à préparer des mets aussi');
    deplacerCurseurXY(30,10);write('généreux qu''appétissants.');

    deplacerCurseurXY(30,12);write('Vous apercevez de nombreux chasseurs assis aux différentes tables de la cantine. Les rires');
    deplacerCurseurXY(30,13);write('et les chants résonnent créant en ce lieu, une ambiance chaleureuse et rassurante.');

    deplacerCurseurXY(30,15);write('Alors que vous vous asseyez à une table, un palico vous rejoint posant devant vous une cho');
    deplacerCurseurXY(30,16);write('pe et attendant votre commande.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Commander un plat avec un bonus de Force');
    deplacerCurseurZoneAction(4);write('     2/ Commander un plat avec un bonus de Régénération');
    deplacerCurseurZoneAction(5);write('     3/ Commander un plat avec un bonus de Critique');
    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  if choix = '0' then cantineHUB := ville
  else cantineHUB := ChoixPage(StrToInt(choix));

end;
end.

