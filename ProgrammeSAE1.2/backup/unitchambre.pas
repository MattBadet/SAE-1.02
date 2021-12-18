//Unit en charge de la chambre
unit unitChambre;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses unitLieu;
//----- FONCTIONS ET PROCEDURES -----
//Fonction exécutée à l'arrivée dans la chambre la première fois
//Renvoie le prochain lieu à visiter
function chambrePremiereFois() : typeLieu; 

//Fonction exécutée à l'arrivée dans la chambre (hors première fois)
//Renvoie le prochain lieu à visiter
function chambreHub() : typeLieu;

//Fonction exécutée quand le joeur regarde son coffre
//Renvoie le prochain lieu à visiter
function coffreEquipement() : typeLieu;




implementation
uses
  unitIHM,unitASCII,unitPersonnage,unitEquipement,GestionEcran;

 
//Fonction exécutée lors du repos
//Renvoie le prochain lieu à visiter
function repos() : typeLieu;
begin
    dormir();
    afficherInterfacePrincipale();

    afficherLieu('Dans votre lit');
    afficherSleep();   
    deplacerCurseurZoneResponse();
    readln;
    repos := chambre;
end;

//Fonction exécutée à l'arrivée dans la chambre la première fois
//Renvoie le prochain lieu à visiter
function chambrePremiereFois() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '1') and (choix <> '2') and (choix <> '3') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Dans les vapes');

    deplacerCurseurXY(30,7);write('Vous vous réveillez dans un lit, une légère douleur à la tête. En vous relevant lentement,');
    deplacerCurseurXY(30,8);write('vous observez autour de vous. La pièce est relativement sombre, mais un feu crépitant dans');
    deplacerCurseurXY(30,9);write('la cheminée diffuse une lumière chaude dans la pièce.');

    deplacerCurseurXY(30,11);write('Les murs de la pièce sont recouvert de tableaux et de têtes de monstres empaillées. Sur la');
    deplacerCurseurXY(30,12);write('porte, vous reconnaissez les armoiries de la sixième compagnie.');

    deplacerCurseurXY(30,14);write('Vous sentez alors une main se poser sur votre épaule et vous entendez quelqu''un derrière');
    deplacerCurseurXY(30,15);write('vous dire :');

    couleurTexte(Cyan);
    deplacerCurseurXY(30,17);write('"Vous voilà enfin réveillé ! Vous avez fait une mauvaise chute sur la bateau, nous avons dû');
    deplacerCurseurXY(30,18);write('vous porter jusqu''à votre chambre ! Dépêchez-vous de vous remettre sur pied, la plupart des');
    deplacerCurseurXY(30,19);write('autres membres de la compagnie sont déjà partis en chasse ! Nous avons rangé votre équipe');
    deplacerCurseurXY(30,20);write('ment dans le coffre là-bas. Equipez-vous et au boulot !"');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Vous reposer dans votre lit');
    deplacerCurseurZoneAction(4);write('     2/ Regarder dans votre coffre');
    deplacerCurseurZoneAction(5);write('     3/ Sortir de votre chambre');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '1' : chambrePremiereFois := repos();
       '2' : chambrePremiereFois := coffreEquipement();
       '3' : chambrePremiereFois := ville;
  end;

end;

//Fonction exécutée à l'arrivée dans la chambre (hors première fois)
//Renvoie le prochain lieu à visiter
function chambreHub() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '1') and (choix <> '2') and (choix <> '3') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Dans votre chambre');

    deplacerCurseurXY(30,7);write('Vous êtes dans votre chambre. Un petit feu crépite dans la cheminée dégageant une douce cha');
    deplacerCurseurXY(30,8);write('leur et une légère lumière dans toute la salle. Sur les murs se trouvent de nombreux objets');
    deplacerCurseurXY(30,9);write('principalement des trophées de chasse.');

    deplacerCurseurXY(30,11);write('Dans un coin de la chambre se trouve un lit dans lequel vous pouvez vous reposer.');

    deplacerCurseurXY(30,13);write('Près de la porte, un grand coffre contient les différentes armes et armures que vous avez');
    deplacerCurseurXY(30,14);write('obtenues au cours de vos nombreuses aventures.');

    deplacerCurseurXY(30,16);write('Enfin, une porte en bois donne accès à la cour principale de la ville de laquelle provient');
    deplacerCurseurXY(30,17);write('le bruit rassurant de l''activité de la compagnie.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Vous reposer dans votre lit');
    deplacerCurseurZoneAction(4);write('     2/ Regarder dans votre coffre');
    deplacerCurseurZoneAction(5);write('     3/ Sortir de votre chambre');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '1' : chambreHub := repos();
       '2' : chambreHub := coffreEquipement(); 
       '3' : chambreHub := ville;
  end;

end;

//Fonction exécutée quand le joeur regarde son coffre
//Renvoie le prochain lieu à visiter
function coffreEquipement() : typeLieu;
var
  ligne,mat,slot,nbchoix,choix,i : integer;
begin
     choix := -1;
     while(choix <> 0) do
     begin
        afficherInterfacePrincipale();
        afficherLieu('Coffre d''équipements');
        deplacerCurseurXY(63,5);write('Votre coffre contient :');

        deplacerCurseurXY(5,7);write('--- ARMES ---');
        deplacerCurseurXY(85,7);write('--- ARMURES ---');

        //ARMES
        ligne := 9;
        nbchoix := 1;
        for mat := 1 to ord(high(materiaux)) do
          if getCoffre().armes[mat] then
          begin
             deplacerCurseurXY(5,ligne);writeln(nbchoix,'/ ',armeToString(materiaux(mat)));
             nbchoix += 1;
             ligne += 1;
          end;

        //ARMURES
        ligne := 9;
        nbchoix := 10;
        for mat := 1 to ord(high(materiaux)) do
            for slot := 0 to 4 do
                if getCoffre().armures[slot,mat] then
                begin
                     deplacerCurseurXY(85,ligne);write(nbchoix,'/ ',armureToString(emplacementArmure(slot),materiaux(mat)));
                     nbchoix += 1;
                     ligne += 1;
                end;

        deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
        deplacerCurseurZoneAction(3);write('     ?/ Vous équiper d''une arme (entrer son numéro)');
        deplacerCurseurZoneAction(4);write('     ?/ Vous équiper d''une armure (entrer son numéro)');
        deplacerCurseurZoneAction(5);write('     0/ Fermer votre coffre');


        deplacerCurseurZoneResponse();
        readln(choix);

        //Changement d'arme
        if(choix >= 1) and (choix < 10) then
        begin
             //On détermine l'arme sélectionnée
             i:=0;
             mat:=1;
             while(i<choix) and (mat<=4) do
             begin
                  if getCoffre().armes[mat] then i += 1;
                  if(i<choix) then
                  begin
                       mat += 1;
                  end;
             end;
             //Si arme trouvée, changer d'arme
             if(i=choix) then changerArme(mat);

        end
        //Changement d'armure
        else if (choix > 0) then
        begin
             //On détermine l'armure sélectionnée
             i:=9;
             mat:=1;
             slot:=0;
             while(i<choix) and (mat<=4) do
             begin
                  if getCoffre().armures[slot,mat] then i += 1;
                  if(i<choix) then
                  begin
                    slot += 1;
                    if(slot = 5) then
                    begin
                         slot := 0;
                         mat += 1;
                    end;
                  end;
             end;
             //Si armure trouvée, changer d'armure
             if(i=choix) then changerArmure(slot,mat);
        end;
     end;

    coffreEquipement:=chambre;
end;

end.

