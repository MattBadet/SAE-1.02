unit unitCampEntrainement;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
//----- FONCTIONS ET PROCEDURES -----
uses
  unitLieu;
//Fonction exécutée à l'arrivée dans le camp d'entrainement
//Renvoie le prochain lieu à visiter
function campHUB() : typeLieu;

implementation
uses
  sysutils,unitPersonnage,unitIHM,GestionEcran;

//Fonction exécutée pour afficher l'écran d'affichage des compétences
//Renvoie le prochain lieu à visiter
function choixCompetence() : typeLieu;
var choix : string;
  choixNumber : integer;
begin
  choix := '';
  while (choix <> '0') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Camp d''entrainement de la ville de Brightwood');

    deplacerCurseurXY(60,5);write('Le maître d''arme vous propose :');
    dessinerCadreXY(23,8,69,27,simple,white,black);
    dessinerCadreXY(35,7,57,9,simple,white,black);
    dessinerCadreXY(23,22,69,27,simple,white,black);
    deplacerCurseurXY(39,8);write('--- TRANCHE ---');
    deplacerCurseurXY(25,10);write('Description : ');
    deplacerCurseurXY(25,15);write('Effet : ');
    deplacerCurseurXY(29,24);write('Prix');
    deplacerCurseurXY(29,25);write('LVL');

    couleurTexte(Red);
    dessinerCadreXY(79,8,125,27,simple,white,black);
    dessinerCadreXY(91,7,113,9,simple,white,black);
    dessinerCadreXY(79,22,125,27,simple,white,black);
    deplacerCurseurXY(95,8);write('--- VOL VIE ---');
    deplacerCurseurXY(81,10);write('Description : ');
    deplacerCurseurXY(81,15);write('Effet : ');
    deplacerCurseurXY(85,24);write('Prix');
    deplacerCurseurXY(85,25);write('LVL');

    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Apprendre Tranche');
    deplacerCurseurZoneAction(4);write('     2/ Apprendre Vol Vie');

    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);

    //Si l'utilisateur saisit 0 => sortir
    if(choix = '0') then choixCompetence := ville
    //Si l'utilisateur saisit un nombre, convertir choix (string) en choixNumber (integer)
    else if(TryStrToInt(choix,choixNumber)) then
    begin
         //Si la recette existe, la manger
         if(choixNumber > 0) and (choixNumber < 3) then ;
    end;
  end;


end;


//Fonction exécutée à l'arrivée dans le camp d'entrainement
//Renvoie le prochain lieu à visiter
function campHUB() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '0') and (choix <> '1') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Camp d''entrainement de la ville de Brightwood');

    deplacerCurseurXY(30,7);write('Alors que vous vous approchez du camp d''entrainement de la ville, vous commencez à');
    deplacerCurseurXY(30,8);write('entendre le bruit des épées qui s''entrechoque et des cris de rage des héros. Vous');
    deplacerCurseurXY(30,9);write('n''êtes apparement pas le seul à chercher à en apprendre plus et a améliorer ses');
    deplacerCurseurXY(30,10);write('techniques de combat.');

    deplacerCurseurXY(30,12);write('A votre arrivé, de la poussière vole entre les combattants entre lesquels vous');
    deplacerCurseurXY(30,13);write('arrivez à vous faufiller pour vous diriger vers le maître d''arme.');

    deplacerCurseurXY(30,15);write('Il vous regarde, debout, une épée a la main dont il se sert comme d''une canne. Il');
    deplacerCurseurXY(30,16);write('vous demande alors si vous êtes ici pour apprendre ses techniques spécial, contre');
    deplacerCurseurXY(30,17);write('une certaine somme d''argent bien évidemment.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Apprendre une compétence');

    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '0' : campHUB := ville;
       '1' : campHUB := choixCompetence();
  end;

end;

end.
