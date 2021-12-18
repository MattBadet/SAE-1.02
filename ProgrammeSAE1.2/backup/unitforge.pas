unit unitForge;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
    unitLieu;
//----- FONCTIONS ET PROCEDURES -----
//Fonction exécutée à l'arrivée dans la forge
//Renvoie le prochain lieu à visiter
function ForgeHUB() : typeLieu;


implementation
uses
    unitPersonnage,unitEquipement,unitIHM,GestionEcran;

//Fonction exécutée quand le joueur souhaite faire fabriquer une arme ou une armure
//Renvoie le prochain lieu à visiter
function fabricationEquipement() : typeLieu;
var
  ligne,mat,slot,nbchoix,choix,i : integer;
begin
     choix := -1;
     while(choix <> 0) do
     begin
        afficherInterfacePrincipale();
        afficherLieu('Forge de la ville de Brightwood');
        deplacerCurseurXY(63,5);write('Les forgerons vous proposent :');

        deplacerCurseurXY(4,7);write('--- ARMES ---');
        deplacerCurseurXY(80,7);write('--- ARMURES ---');

        //Fabrication des ARMES
        for mat := 1 to ord(high(materiaux)) do
        begin
           //Arme déja possédée
           if(getCoffre().armes[mat]) or (ord(getPersonnage().arme) = mat) then
           begin
                couleurTexte(green);
                deplacerCurseurXY(34,8+mat);write('(Déjà possédé(e))');
           end
           else
           begin 
              //Arme non fabricable
              if not(peuxForger(materiaux(mat))) then couleurTexte(lightred);
              //Affichage de la recette
              deplacerCurseurXY(34,8+mat);writeln(recetteToString(materiaux(mat)));
           end;
           deplacerCurseurXY(4,8+mat);writeln(mat,'/ ',armeToString(materiaux(mat)));
           couleurTexte(white);
        end;

        //Fabrication des ARMURES
        ligne := 9;
        nbchoix := 10;
        for mat := 1 to ord(high(materiaux)) do
        begin
            for slot := 0 to 4 do
            begin 
                //Armure déja possédée
                if(getCoffre().armures[slot,mat]) or (ord(getPersonnage().armures[slot]) = mat) then
                begin
                     couleurTexte(green);
                     deplacerCurseurXY(110,ligne);write('(Déjà possédé(e))');
                end
                //Armure non fabricable
                else
                begin
                    if not(peuxForger(materiaux(mat))) then couleurTexte(lightred);
                    deplacerCurseurXY(110,ligne);writeln(recetteToString(materiaux(mat)));
                end;
                deplacerCurseurXY(80,ligne);write(nbchoix,'/ ',armureToString(emplacementArmure(slot),materiaux(mat)));
                nbchoix += 1;
                ligne += 1;
                couleurTexte(white);
            end;
            ligne +=1;
        end;

        deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
        deplacerCurseurZoneAction(3);write('     ?/ Faire fabriquer une arme (entrer son numéro)');
        deplacerCurseurZoneAction(4);write('     ?/ Faire fabriquer une armure (entrer son numéro)');
        deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');


        deplacerCurseurZoneResponse();
        readln(choix);

        //Demande de fabrication d'une arme
        if(choix < 4) and (choix > 0) then
        begin
             //Si on peu la faire et si on ne la possède pas déjà
             if(peuxForger(materiaux(choix))) and (not (getCoffre().armes[choix])) and (not (ord(getPersonnage().arme) = choix)) then
                forgerArme(materiaux(choix));
        end;
        //Demande de fabrication d'une armure
        if(choix < 25) and (choix > 9) then
        begin
             mat := ((choix-10) div 5)+1;
             slot := (choix-10) mod 5;
             //Si on peu la faire et si on ne la possède pas déjà
             if(peuxForger(materiaux(mat))) and (not (getCoffre().armures[slot,mat])) and (not (ord(getPersonnage().armures[slot]) = mat)) then
                forgerArmure(slot,materiaux(mat));
        end;

     end;

    fabricationEquipement:=ville;
end;


//Fonction exécutée à l'arrivée dans la forge
//Renvoie le prochain lieu à visiter
function ForgeHUB() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '0') and (choix <> '1') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Forge de la ville de Brightwood');

    deplacerCurseurXY(30,7);write('Vous vous faites un chemin à travers l''épaisse fumée qui s''échappe de la forge de la ville.');
    deplacerCurseurXY(30,8);write('L''air est lourd et il se dégage une forte odeur, mélange de souffre et de fer fondu. A l''o');
    deplacerCurseurXY(30,9);write('deur se rajoutent la chaleur intense des fourneaux et le bruit incessant des marteaux frap'); 
    deplacerCurseurXY(30,10);write('pant le métal.');

    deplacerCurseurXY(30,12);write('C''est ici que la plupart des armures et des armes des chasseurs voient le jour. Les maitres');
    deplacerCurseurXY(30,13);write('forgerons peuvent fabriquer l''équipement de votre choix en échange de partie de monstres et');
    deplacerCurseurXY(30,14);write('de quelques pièces.');

    deplacerCurseurXY(30,16);write('A votre arrivée, un homme a la musculature impressionnante se tourne vers vous afin de pren');
    deplacerCurseurXY(30,17);write('dre votre commande.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Commander une pièce d''équipement');

    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '0' : ForgeHUB := ville;
       '1' : ForgeHUB := fabricationEquipement();
  end;

end;



end.       .

