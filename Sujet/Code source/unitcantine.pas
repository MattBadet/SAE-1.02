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

//Mange le plat et applique le bonus
procedure manger(nbPlat : integer);
begin
     //Fixe le buff
     setBuff(bonus(nbPlat));
end;
       
//Fonction exécutée pour afficher l'écran d'affichage des recettes
//Renvoie le prochain lieu à visiter
function choixRecette() : typeLieu;
var choix : string;
  choixNumber : integer;
begin
  choix := '';
  while (choix <> '0') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Cantine de la ville de Brightwood');
                                                        
    deplacerCurseurXY(63,5);write('Le cuisinier vous proposent :');
    couleurTexte(Cyan);
    deplacerCurseurXY(30,7);write('Plat');
    deplacerCurseurXY(70,7);write('Bonus');  
    couleurTexte(White);
    deplacerCurseurXY(30,9);write('1/ Un ragoût de viande');
    deplacerCurseurXY(70,9);write('(Force)');
    deplacerCurseurXY(30,10);write('2/ Un sauté de légume'); 
    deplacerCurseurXY(70,10);write('(Regénération)');

    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     ?/ Commander un plat (entrer son numéro)');

    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);

    //Si l'utilisateur saisit 0 => sortir
    if(choix = '0') then choixRecette := ville
    //Si l'utilisateur saisit un nombre, convertir choix (string) en choixNumber (integer)
    else if(TryStrToInt(choix,choixNumber)) then
    begin
         //Si la recette existe, la manger
         if(choixNumber > 0) and (choixNumber < 3) then manger(choixNumber);
    end;
  end;


end;

//Fonction exécutée à l'arrivée dans la cantine
//Renvoie le prochain lieu à visiter
function cantineHUB() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '0') and (choix <> '1') do
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
    deplacerCurseurZoneAction(3);write('     1/ Commander un plat');

    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '0' : cantineHUB := ville;
       '1' : cantineHUB := choixRecette();
  end;

end;
end.

