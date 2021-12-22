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

{function recupRecette(n : integer): array of string;

var
  t1 : array of string;
  t2 : array of string;
  t3 : array of string;

begin
  case n of
  1: recupRecette := t1;
  2: recupRecette := t2;
  3: recupRecette := t3;
  end;
end;}

//Fonction exécutée pour afficher l'écran d'affichage des recettes
//Renvoie le prochain lieu à visiter
function choixPage(n : integer) : typeLieu;
var choix : string;
  recette : array of string;
  choixNumber : integer;
begin

  //recette := recupRecette(n);

  choix := '';
  while (choix <> '0') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Cantine de la ville de Brightwood');
                                                        
    deplacerCurseurXY(63,5);write('Le cuisinier vous proposent :');
    deplacerCurseurXY(40,7);write(' 1/ Ragoût de crevettes aux gombos avec du riz à la menthe');
    deplacerCurseurXY(40,8);write(' 2/ Mijoté de calamars aux navets avec des lentilles à la coriandre');
    deplacerCurseurXY(40,9);write(' 3/ Porc grillé aux edamames avec des lentilles à la coriandre');
    deplacerCurseurXY(40,10);write(' 4/ Tajine de truite à la betterave avec des haricots rouges à la ciboulette');
    deplacerCurseurXY(40,11);write(' 5/ Mijoté de hareng au chou avec de l''orge à l''aneth');
    deplacerCurseurXY(40,12);write(' 6/ Salade de crabe à la patate douce avec du riz à l''aneth');
    deplacerCurseurXY(40,13);write(' 7/ Ragoût de porc aux brocolis avec des lentilles au persil');
    deplacerCurseurXY(40,14);write(' 8/ Ragoût de thon à la patate douce avec de l''orge à la ciboulette');
    deplacerCurseurXY(40,15);write(' 9/ Sauté de porc aux épinards avec de l''orge au basilic');
    deplacerCurseurXY(40,16);write('10/ Mijoté de pintade au choux-fleur avec des petits pois à l''aneth');
    deplacerCurseurXY(40,17);write('11/ Tajine de poulet aux endives avec du riz à la ciboulette');
    deplacerCurseurXY(40,18);write('12/ Mijoté de veau aux pommes de terre avec des fèves à la ciboulette');
    deplacerCurseurXY(40,19);write('13/ Salade de crevettes aux champignons avec des lentilles au basilic');
    deplacerCurseurXY(40,20);write('14/ Poulet frit aux champignons avec des petits pois à l''aneth');
    deplacerCurseurXY(40,21);write('15/ Salade de poulet aux asperges avec de l''orge au basilic');
    deplacerCurseurXY(40,22);write('16/ Dinde frite aux brocolis avec de l''orge au persil');
    deplacerCurseurXY(40,23);write('17/ Mijoté de crabe à la courgette avec des fèves à la coriandre');
    deplacerCurseurXY(40,24);write('18/ Ragoût de thon à la patate douce avec des fèves au persil');
    deplacerCurseurXY(40,25);write('19/ Sauté de porc au célerie avec des haricots rouges au persil');
    deplacerCurseurXY(40,25);write('20/ Curry de dinde aux champignons avec des pâtes au persil');

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

