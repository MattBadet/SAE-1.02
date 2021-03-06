//Unit en charge de la cantine
unit unitCantine;
{$codepage utf8}
{$mode objfpc}{$H+}

interface

//----- FONCTIONS ET PROCEDURES -----
uses
  unitLieu;

//Fonction exécutée à l'arrivée dans la cantine
//Renvoie le prochain lieu à visiter
function cantineHUB() : typeLieu;












implementation
uses
  sysutils,unitPersonnage,unitIHM,GestionEcran;
type
  strarray = array[1..2] of string;
  tablarray = array[1..1721] of string; //Tableau des recettes
var
  tablcrit:tablarray;  //RecettesCritique
  tablregen:tablarray; //RecettesRegen    1633 elem
  tablforc:tablarray;  //RecettesForce    1655 elem

// Tri par Insertion des recettes
{procedure triInsertion(var t:tablarray);
var
   temp:string;
   i,j,k:Integer;
   p:Boolean;
begin
  for k:=1 to 1000 do
  begin
    for i:=2 to 1721 do
    begin
        temp:=t[i];
        j:=i-1;
        p:=False;
        while p=False do
        begin
            if j>1 then
            begin
              if t[j]>t[j+1] then
              begin
                t[j+1]:=t[j];
                t[j]:=temp;
              end
              else
              begin
                  p:=True;
                  j:=j-1;
              end;
            end
            else
            begin
                p:=True;
                j:=j-1;
            end;
        end;
    end;
  end;
end;}
procedure triInsertion(var t:tablarray;var ordre:Boolean);
var
   temp:string;    // temp servent pour les inversions des valeurs
   i,j,k:Integer; // compteurs pour les boucles for
   p:Boolean;    // pour arrêter le tri dans le tableaux
begin
  if ordre then   // permet de savoir l'ordre dans lequel trier
  begin
    for k:=1 to 1630 do  // pour effectuer plusieurs fois le tri afin de bien trier
    begin
      for i:=2 to 1721 do // pour parcourir tout le tableaux
      begin
          temp:=t[i];      // sauveagarde la valeur de l'indice i pour le permetuer plus tard
          j:=i-1;
          p:=False;
          while p=False do  // tant que p faux trier
          begin
              if j>1 then
              begin
                if t[j]>t[j+1] then
                begin
                  t[j+1]:=t[j];
                  t[j]:=temp;
                end
                else
                begin
                    p:=True;
                    j:=j-1;
                end;
              end
              else
              begin
                  p:=True;
                  j:=j-1;
              end;
          end;
      end;
    end;
    ordre:=False;
  end
  else
  begin
    for k:=1 to 1630 do
    begin
      for i:=2 to 1721 do
      begin
          temp:=t[i];
          j:=i-1;
          p:=False;
          while p=False do
          begin
              if j>1 then
              begin
                if t[j]<t[j+1] then
                begin
                  t[j+1]:=t[j];
                  t[j]:=temp;
                end
                else
                begin
                    p:=True;
                    j:=j-1;
                end;
              end
              else
              begin
                  p:=True;
                  j:=j-1;
              end;
          end;
      end;
    end;
    ordre:=True;
  end;
end;

//Mange le plat et applique le bonus
procedure manger(nbPlat : integer);
begin
  //Si argent suffisant
  if(getPersonnage().argent > 200-(50*(nbPlat-1))) then
  begin
     //Fixe le buff
     case nbPlat of
     1:setBuff(Force,200-(50*(nbPlat-1)));
     2:setBuff(Regeneration,200-(50*(nbPlat-1)));
     3:setBuff(Critique,200-(50*(nbPlat-1)));
     end;
  end;
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

procedure recupRecette;
var
 FileVar:TextFile;
 str : string;
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
end;

//Renvoie un tableau contenant les recettes d'un certain buff
function recupRecetteHUB(n:integer):tablarray;
begin
  recupRecette;
  case n of
    1: recupRecetteHUB:=tablforc;
    2: recupRecetteHUB:=tablregen;
    3: recupRecetteHUB:=tablcrit;
  end;
end;

//Fonction exécutée pour afficher l'écran d'affichage des recettes
//Renvoie le prochain lieu à visiter
function choixPage(n : integer) : typeLieu;
var choix : string;
  recette : tablarray;      //Tableau contenant les recettes à afficher
  nRecette : integer;       //Recette à laquelle commencer la page
  recetteVoulu : integer;   //Recette choisit par l'utilisateur
  pageVoulu : integer;      //Page choisit par l'utilisateur
  page : integer;           //Page actuelle
  pageMax : integer;        //Nombre de pages pour ce buff
  i : integer;              //Compteur de boucle pour l'affichage des 20 recettes par page
  ordreTri : boolean;       //Pour savoir dans quel ordre trier les recettes
begin
  page := 1;
  recette := recupRecetteHUB(n);
  ordreTri:=True;
  //Nombre de page pour chaque buff
  case n of
  1:pageMax:=83; //Force
  2:pageMax:=82; //Regen
  3:pageMax:=86; //Critique
  end;

  choix := '';
  while (choix <> '0') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Cantine de la ville de Brightwood');

    nRecette := ((page * 20) - 19);
    deplacerCurseurXY(63,5);write('Le cuisinier vous proposent :');
    //Boucle d'affichage des 20 recettes
    for i:=1 to 20 do
    begin
    if(recette[nRecette+i]) <> '' then
    begin
      deplacerCurseurXY(40,i+6);write(' ', i,'/ ');write(recette[nRecette+i]);
    end;
    end;

    //Affichage buff actuel
    dessinerCadreXY(1,27,21,29,simple,white,black);
    deplacerCurseurXY(2,28);write('Buff : ');
    case n of
    1:write('Force');
    2:write('Régénération');
    3:write('Critique');
    end;
    //Affichage prix
    dessinerCadreXY(1,7,14,9,simple,white,black);
    if(getPersonnage().argent > 200-(50*(n-1))) then couleurTexte(Green)
    else couleurTexte(lightred);
    deplacerCurseurXY(2,8);write('Prix : ');
    case n of
    1:write(200-(50*(n-1)),'PO');
    2:write(200-(50*(n-1)),'PO');
    3:write(200-(50*(n-1)),'PO');
    end;
    //Affichage page
    dessinerCadreXY(132,27,147,29,simple,white,black);
    deplacerCurseurXY(133,28);write('Page : ',page,' / ',pageMax);

    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Inverser l''ordre alphabéthique');
    deplacerCurseurZoneAction(5);write('     2/ Choisir une page par numéro');
    deplacerCurseurZoneAction(7);write('     3/ Page précédente');
    deplacerCurseurXY(55,33);write('     4/ Page suivante');
    deplacerCurseurXY(55,35);write('     5/ Choisir un plat sur la page');
    deplacerCurseurXY(55,37);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);

    //Si l'utilisateur saisit 0 => sortir
    if(choix = '0') then choixPage := ville
    else if(choix = '1') then //Triage Tableau
    begin
      triInsertion(recette,ordreTri);
    end
    else if(choix = '2') then //Choix d'une page
    begin
      afficherCadreAction();
      afficherCadreResponse();
      deplacerCurseurXY(5,33);write('Rentrez la page où vous souhaitez vous rendre.');
      deplacerCurseurXY(5,34);write('Cette page doit évidemment être possible');
      deplacerCurseurXY(5,35);write('en fonction du nombre de page existantes');
      deplacerCurseurZoneResponse();
      readln(pageVoulu);
      if(pageVoulu >= 1) AND(pageVoulu <= pageMax) then page:=pageVoulu;
    end
    else if(choix = '3') then //Page précédente
    begin
      if(page <> 1) then page -= 1;
    end
    else if(choix = '4') then //Page suivante
    begin
      if(page <> pageMax) then page += 1
    end
    else if(choix = '5') then //Choisir une recette sur la page
    begin
      afficherCadreAction();
      afficherCadreResponse();
      deplacerCurseurXY(5,33);write('Rentrez la recette que vous souhaitez manger.');
      deplacerCurseurXY(5,34);write('Cette recette doit évidemment être disponible');
      deplacerCurseurXY(5,35);write('en fonction des nombre de recettes affiché');
      deplacerCurseurZoneResponse();
      readln(recetteVoulu);
      if(recette[nRecette+recetteVoulu]) <> '' then manger(n);
    end
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

