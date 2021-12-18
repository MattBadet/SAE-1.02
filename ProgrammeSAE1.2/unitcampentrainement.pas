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
  end;

end;

end.

