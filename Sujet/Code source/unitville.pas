//Unit en charge de la ville
unit unitVille;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses unitLieu;

//----- FONCTIONS ET PROCEDURES -----
//Fonction exécutée à l'arrivée dans la ville
//Renvoie le prochain lieu à visiter
function villeHub() : typeLieu;













implementation
uses
    unitIHM,GestionEcran;

//Fonction exécutée à l'arrivée dans la ville
//Renvoie le prochain lieu à visiter
function villeHub() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '1') and (choix <> '2') and (choix <> '3') and (choix <> '4') and (choix <> '5') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Ville de Brightwood');

    deplacerCurseurXY(30,7);write('Vous vous trouvez sur la place centrale de la ville de Brightwood. Le lieu est empli du bru');
    deplacerCurseurXY(30,8);write('it de ses habitants. Partout autour de vous, les gens s''affèrent à leur travail, courant de');
    deplacerCurseurXY(30,9);write('-ci de-là, portant caisses et objets en tous genres.');

    deplacerCurseurXY(30,11);write('Au nord résonne le son des marteaux de la grande forge. On y fabrique probablement de nou');
    deplacerCurseurXY(30,12);write('velles armes et armures à partir des matériaux rapportés par les chasseurs.');

    deplacerCurseurXY(30,14);write('A l''est se trouve les étales des marchands. On y vend toutes sortes d''objets qui pourraient');
    deplacerCurseurXY(30,15);write('vous être utiles dans vos futures chasses. :');

    deplacerCurseurXY(30,17);write('Un épais fumet de poisson et de viande émane des cuisines de la cantine située prêt des éta');
    deplacerCurseurXY(30,18);write('les des marchands. Pourquoi ne pas s''y arrêter manger un coup ?');

    deplacerCurseurXY(30,20);write('A l''ouest se trouve les dortoirs des chasseurs dans lesquels se trouve votre chambre.');

    deplacerCurseurXY(30,22);write('Et enfin, au sud, se trouve la porte principale de la ville d''où partent les chasses.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Se rendre à votre chambre');
    deplacerCurseurZoneAction(4);write('     2/ Se rendre aux marchands');
    deplacerCurseurZoneAction(5);write('     3/ Se rendre à la forge'); 
    deplacerCurseurZoneAction(6);write('     4/ Se rendre à la cantine');
    deplacerCurseurZoneAction(7);write('     5/ Se rendre à la porte');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '1' : villeHub := chambre;
       '2' : villeHub := marchand;
       '3' : villeHub := forge;  
       '4' : villeHub := cantine;
       '5' : villeHub := expedition;
  end;

end;

end.

