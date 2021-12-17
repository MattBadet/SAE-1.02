//Unit en charge du marchand
unit unitMarchand;
{$codepage utf8}
{$mode objfpc}{$H+}

interface  
uses unitLieu;
//----- FONCTIONS ET PROCEDURES -----
//Fonction exécutée à l'arrivée chez le marchand
//Renvoie le prochain lieu à visiter
function marchandHub() : typeLieu;
















implementation
uses
    unitPersonnage,unitObjet,unitIHM,GestionEcran;

//Fonction exécutée à quand le joueur veut acheter des objets
//Renvoie le prochain lieu à visiter
function marchandAcheter() : typeLieu;
var
  choix : integer;
  i : integer;
begin 
    choix := -1;
    while(choix <> 0) do
    begin
         afficherInterfacePrincipale();
         afficherLieu('Place du marcher');
         deplacerCurseurXY(62,5);write('Le vendeur vous propose :');

         //Affichage des objets
         for i:=1 to nbObjets do
         begin
              deplacerCurseurXY(35,i+8);write(i,'/ ',getObjet(i).nom);
              deplacerCurseurXY(65,i+8);write('Prix : ',getObjet(i).prixAchat);
              deplacerCurseurXY(95,i+8);write('Inventaire : ',getPersonnage().inventaire[i]);
         end;     
         deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
         deplacerCurseurZoneAction(3);write('     ?/ Acheter un objet (entrer son numéro)');

         deplacerCurseurZoneAction(5);write('     0/ Revenir au menu du marchand');

         deplacerCurseurZoneResponse();
         readln(choix);
         //Si l'objet existe
         if(choix <= nbObjets) and (choix > 0) then
                  //Si le joueur à l'argent, acheter l'objet
                  if(getPersonnage().argent >= getObjet(choix).prixAchat) then acheterObjet(choix);
    end;

  marchandAcheter := marchand;
end;

//Fonction exécutée à quand le joueur veut vendre des objets
//Renvoie le prochain lieu à visiter
function marchandVendre() : typeLieu;
var
  choix : integer;
  i : integer;
begin
    choix := -1;
    while(choix <> 0) do
    begin
         afficherInterfacePrincipale();
         afficherLieu('Place du marcher');
         deplacerCurseurXY(62,5);write('Le vendeur peut vous acheter :');

         //Affichage des objets
         for i:=1 to nbObjets do
         begin
              deplacerCurseurXY(35,i+8);write(i,'/ ',getObjet(i).nom);
              deplacerCurseurXY(65,i+8);write('Prix : ',getObjet(i).prixVente);
              deplacerCurseurXY(95,i+8);write('Inventaire : ',getPersonnage().inventaire[i]);
         end;
         deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
         deplacerCurseurZoneAction(3);write('     ?/ Vendre un objet (entrer son numéro)');

         deplacerCurseurZoneAction(5);write('     0/ Revenir au menu du marchand');

         deplacerCurseurZoneResponse();
         readln(choix);
         //Si l'objet existe
         if(choix <= nbObjets) and (choix > 0) then
                  //Si le joueur à au moins un objet de ce type
                  if(getPersonnage().inventaire[i] > 0) then vendreObjet(choix);
    end;

  marchandVendre := marchand;

end;

//Fonction exécutée à l'arrivée chez le marchand
//Renvoie le prochain lieu à visiter
function marchandHub() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '1') and (choix <> '2') and (choix <> '3') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Place du marcher');

    deplacerCurseurXY(30,7);write('La place du marcher est particulièrement agitée. D''un large coup d''oeil vous parcourrez');
    deplacerCurseurXY(30,8);write('du regard les différentes étales.');

    deplacerCurseurXY(30,10);write('En cherchant bien, il est possible de trouver ici à peu prèt tout. A votre droite, un grou');
    deplacerCurseurXY(30,11);write('pe de marchands vend des fruits et des légumes dont seulement certains vous sont familiers.'); 
    deplacerCurseurXY(30,12);write('A votre gauche, d''autres marchands vendent des vêtements aux couleurs vives et variées.');

    deplacerCurseurXY(30,14);write('Mais votre regard est bien vite accroché par une étale particulière. Situé un peu en re');
    deplacerCurseurXY(30,15);write('vous dire :');

    deplacerCurseurXY(30,17);write('Vous voilà enfin réveillé ! Vous avez fait une mauvaise chute sur la bateau, nous avons dû');
    deplacerCurseurXY(30,18);write('trait par rapport aux autres, un marchand vend toutes sortes d''objets pour les chasseurs :');
    deplacerCurseurXY(30,19);write('potions, bombes, plantes... Vous vous approchez de l''étale pour regarder de plus prêt.');

    deplacerCurseurXY(30,21);write('Vous vous approchez des étales des marchands. Vous distinguez de nombreux objets qui pour');
    deplacerCurseurXY(30,22);write('raient vous être utiles dans vos chasses futures.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Acheter des objets');
    deplacerCurseurZoneAction(4);write('     2/ Vendre des objets');
    deplacerCurseurZoneAction(5);write('     3/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '1' : marchandHub := marchandAcheter();
       '2' : marchandHub := marchandVendre();
       '3' : marchandHub := ville;
  end;

end;

end.

