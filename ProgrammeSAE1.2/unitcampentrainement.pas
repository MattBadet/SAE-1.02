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

//Le joueur veux apprendre Tranche
procedure veuxTranche();
begin
  if ((getPersonnage().competence = 0) OR (getPersonnage().competence = 2)) AND (getPersonnage().argent >= 1000) then
  begin
    apprendCompetence(1);
  end;
end;

//Le joueur veux apprendre VolVie
procedure veuxVolVie();
begin
  if ((getPersonnage().competence = 0) OR (getPersonnage().competence = 1)) AND (getPersonnage().argent >= 1000) then
  begin
    apprendCompetence(2);
  end;
end;

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
    deplacerCurseurXY(26,10);write('DESCRIPTION : Avec cette technique, vous');
    deplacerCurseurXY(26,11);write('infligerai un coup rapide à l''ennemie.');
    deplacerCurseurXY(26,12);write('Le faisant ainsi saigner abondemment.');
    deplacerCurseurXY(26,15);write('EFFET : Inflige immédiatement 50% des');
    deplacerCurseurXY(26,16);write('dégats de base. Puis inflige 25% des');
    deplacerCurseurXY(26,17);write('dégats de base chaque tour pendant 3');
    deplacerCurseurXY(26,18);write('tours.');
    if (getPersonnage().argent < 1000) then
    couleurTexte(Red)
    else
    couleurTexte(Green);
    deplacerCurseurXY(40,24);write('Prix : 1000PO');
    if (getPersonnage().competence = 1) OR (getPersonnage().competence = 3) then
    begin
    deplacerCurseurXY(40,25);write('Déjà appris');
    end;

    dessinerCadreXY(79,8,125,27,simple,white,black);
    dessinerCadreXY(91,7,113,9,simple,white,black);
    dessinerCadreXY(79,22,125,27,simple,white,black);
    deplacerCurseurXY(95,8);write('--- VOL VIE ---');
    deplacerCurseurXY(82,10);write('DESCRIPTION : Avec cette attaque magique,');
    deplacerCurseurXY(82,11);write('vous serai capable de voler une partie de');
    deplacerCurseurXY(82,12);write('la vie du monstre qui vous fera face. Et');
    deplacerCurseurXY(82,13);write('D''ainsi vous soigner tout en l''attaquant.');
    deplacerCurseurXY(82,15);write('EFFET : Inflige 66% des dégats de base,');
    deplacerCurseurXY(82,16);write('mais vous soigne en même temps d''autant');
    deplacerCurseurXY(82,17);write('de PV que le nombre enlever au monstre.');
    if (getPersonnage().argent < 1000) then
    couleurTexte(Red)
    else
    couleurTexte(Green);
    deplacerCurseurXY(96,24);write('Prix : 1000PO');
    if (getPersonnage().competence = 2) OR (getPersonnage().competence = 3) then
    begin
    deplacerCurseurXY(96,25);write('Déjà appris');
    end;
    couleurTexte(white);


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
      case choixNumber of
      1:veuxTranche();
      2:veuxVolVie();
    end;
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

