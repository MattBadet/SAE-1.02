//Unité en charge de la chasse
unit unitChasse;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
    unitLieu;
//----- FONCTIONS ET PROCEDURES -----
function chasseHub() : typeLieu;












implementation
uses
    unitEquipement,unitPersonnage,unitMonstre,unitIHM,GestionEcran;

//Fonction gérant le combat contre un monstre
function combat(numMonstre : integer) : typeLieu;
var
  monstre : TMonstre;        //Le monstre
  choix : string;
  degatPerso : integer;      //Dégats réalisés par le perso
  degatMonstre : integer;    //Dégats réalisés par le monstre
  nbPartie : integer;        //Nb de parties récupérées sur le monstre
  lancerBombe : integer;     //Etat du lancé de bombe (-1 pas fait, 0 échoué, 1 réussi)
  boirePotion : integer;     //Etat de l'utilisateur de potion (-1 pas fait, 0 échoué, 1 réussi)
begin
   //On récupère une copie du monstre
   monstre := getMonstre(numMonstre);
   choix := ''; 

   //Affichage initial
   afficherInterfacePrincipale();
   afficherLieu('Combat contre un '+nomMonstre(monstre.typeM));

   deplacerCurseurXY(30,7);write('Un monstre apparait devant vous ! C''est un '+nomMonstre(monstre.typeM));
   deplacerCurseurXY(30,8);write('Vous vous mettez en position pour le combattre !');

   deplacerCurseurXY(30,10);write('  Nom du monstre : ' +nomMonstre(monstre.typeM));
   deplacerCurseurXY(30,11);write('Santé du monstre : ',monstre.pv);

   //Boucle de combat
   while (monstre.pv > 0) and (getPersonnage().sante > 0) do
   begin
        //Initialisation
        degatPerso := -1;
        degatMonstre := -1;
        nbPartie := -1;
        lancerBombe := -1;
        boirePotion := -1;

        if (choix = '1') or (choix = '2') or (choix = '3') or (choix = '4') then
        begin
             //Attaque classique
             if (choix = '1') then
             begin
                  //Dégat du joueur
                  degatPerso := degatsAttaque();
                  //Buff de Force
                  if(getPersonnage().buff = Force) then degatPerso+=1;
                  monstre.pv -= degatPerso;
                  if(monstre.pv < 0) then monstre.pv := 0;
             end
             //Récupération de parties
             else if(choix = '2') then
             begin
                  //Dégat du joueur
                  degatPerso := degatsAttaque() div 2;
                  //Buff de Force
                  if(getPersonnage().buff = Force) then degatPerso+=1;
                  monstre.pv -= degatPerso;
                  if(monstre.pv < 0) then monstre.pv := 0;
                  //Récupération de partie
                  nbPartie := random(2);
                  if(nbPartie > 0) and (degatPerso > 0) then ajouterPartie(numMonstre);

             end
             //Potion
             else if(choix = '3') then
             begin
                  if(getPersonnage().inventaire[0] > 0) then
                  begin
                       soigner();
                       boirePotion := 1;           //Réussite 
                       utiliserObjet(0);
                  end
                  else boirePotion := 0;           //Echec
             end
             //Bombe
             else if(choix = '4') then
             begin
                 if(getPersonnage().inventaire[1] > 0) then
                  begin
                       monstre.stun:=3;
                       lancerBombe := 1;           //Réussite
                       utiliserObjet(1);
                  end
                  else lancerBombe := 0;           //Echec
             end;

             //Contre attaque du monstre
             if(monstre.pv > 0) and (monstre.stun = 0) then
             begin
                  degatMonstre := degatsRecu();
             end
             //réduit le stun de 1
             else if(monstre.pv > 0) then monstre.stun -= 1;
             //Regenration du joueur
             if(getPersonnage.sante>0) and (getPersonnage.buff = Regeneration) then regen();

            afficherInterfacePrincipale();
            afficherLieu('Combat contre un '+nomMonstre(monstre.typeM));

            deplacerCurseurXY(30,7);write('Un monstre apparait devant vous ! C''est un '+nomMonstre(monstre.typeM));
            deplacerCurseurXY(30,8);write('Vous vous mettez en position pour le combattre !');

            deplacerCurseurXY(30,10);write('  Nom du monstre : ' +nomMonstre(monstre.typeM));
            deplacerCurseurXY(30,11);write('Santé du monstre : ',monstre.pv);
            if(monstre.stun > 0) then write(' (étourdi)');




            //Affichage des dégats du joueurs
            if(degatPerso>-1) then
            begin
              couleurTexte(cyan);
              if(getPersonnage.buff = Force) then
              begin
                 deplacerCurseurXY(30,15);write('Vous attaquez le monstre avec ',armeToString(getPersonnage().arme)+' et lui faites ',degatPerso,' point(s) de dégats (dont 1 point bonus)');
              end
              else
              begin
                  deplacerCurseurXY(30,15);write('Vous attaquez le monstre avec ',armeToString(getPersonnage().arme)+' et lui faites ',degatPerso,' point(s) de dégats');
              end;
              if(nbPartie > 0) and (degatPerso > 0) then
              begin
                   deplacerCurseurXY(30,16);write('Vous avez réussi à récupérer une partie du monstre.');
              end
              else if(nbPartie = 0) then
              begin
                   deplacerCurseurXY(30,16);write('Vous n''avez pas réussi à récupérer une partie du monstre.');
              end;
              if(monstre.pv = 0) then
              begin
                   deplacerCurseurXY(30,17);write('Le monstre s''effondre ! Félicitations, vous l''avez vaincu !');
              end;
            end;
            //Boire potion
            if(boirePotion>-1) then
            begin     
                couleurTexte(cyan);
                if(boirePotion = 0) then
                begin
                     deplacerCurseurXY(30,15);write('Vous essayez de boire une potion mais vous n''en avez plus !');
                end
                else if(boirePotion = 1) then
                begin
                     deplacerCurseurXY(30,15);write('Vous buvez une potion qui vous soigne de 50 points de vie.');
                end;
            end;
            //Lancer une bombe
            if(lancerBombe>-1) then
            begin  
                couleurTexte(cyan);
                if(lancerBombe = 0) then
                begin
                     deplacerCurseurXY(30,15);write('Vous essayez de lancer une bombe mais vous n''en avez plus !');
                end
                else if(lancerBombe = 1) then
                begin
                     deplacerCurseurXY(30,15);write('Vous lanvez une bombe sur le monstre qui est étourdi !');
                end;
            end;
            //Affichage des dégats du monstres
            if(degatMonstre > -1) then
            begin
                 couleurTexte(lightred);
                 deplacerCurseurXY(30,19);write('Le monstre vous attaque et vous fait ',degatMonstre,' point(s) de dégats');
                 if(getPersonnage().sante = 0) then
                 begin
                      deplacerCurseurXY(30,20);write('Vous vous effondrez... Le monstre a eu raison de vous...');
                 end  
                 //Buff de regénération
                 else if(getPersonnage().buff = Regeneration) then
                 begin
                      couleurTexte(green);
                      deplacerCurseurXY(30,21);write('Vous vous regénérez de 1 PV.');
                 end;
            end;
            if(monstre.pv > 0) and (monstre.stun > 0) then
            begin
               couleurTexte(lightred);
               deplacerCurseurXY(30,19);write('Le monstre essaye de reprendre ses esprits...');
            end;


            couleurTexte(White);
        end;

        //Choix d'action
        if (monstre.pv > 0) and (getPersonnage().sante > 0) then
        begin
          deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
          deplacerCurseurZoneAction(3);write('     1/ Attaquer le monstre de toute votre force');
          deplacerCurseurZoneAction(4);write('     2/ Essayer de récupérer une partie du monstre');
          deplacerCurseurZoneAction(5);write('     3/ Utiliser une potion');
          deplacerCurseurZoneAction(6);write('     4/ Utiliser une bombe');
        end;
        deplacerCurseurZoneResponse();
        readln(choix);
   end;
   //Victoire
   if(monstre.pv = 0) then
   begin
         recupererPrime(monstre.prime);
         setBuff(AucunB);
         combat := expedition;
   end
   //Mort
   else 
   begin
        combat := menuPrincipal;
   end;
end;

//Fonction exécutée à l'arrivée à la porte principale de la ville
//Renvoie le prochain lieu à visiter
function chasseHub() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '0') and (choix <> '1') and (choix <> '2') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Portes de la ville de Brightwood');

    deplacerCurseurXY(30,7);write('Vous arrivez à la porte principale de la ville de Brightwood. La ville est fermée par une');
    deplacerCurseurXY(30,8);write('immense porte de bois gardée par plusieurs chasseurs expérimentés. Vous vous demandez si de');
    deplacerCurseurXY(30,9);write('telles défenses peuvent vraiment protéger la ville d''une horde de monstres...');

    deplacerCurseurXY(30,11);write('Au pied de la porte se trouve un tableau regroupant les différentes primes de chasses. Vous');
    deplacerCurseurXY(30,12);write('reconnaissez plusieurs chasseurs en train de regarder ce tableau à la recherche de leurs fu');
    deplacerCurseurXY(30,13);write('tures chasses.');

    deplacerCurseurXY(30,15);write('Vous vous approchez du tableau et parcourrez les différentes primes. Certaines vous semblent');
    deplacerCurseurXY(30,16);write('bien trop dangereuses mais vous remarquez que l''on cherche des volontaires pour chasser des');
    deplacerCurseurXY(30,17);write('Grand Jagras et des Pukei-Pukei.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Partir chasser le Grand Jagras');
    deplacerCurseurZoneAction(4);write('     2/ Partir chasser le Pukei-Pukei');
    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '0' : chasseHub := ville;
       '1' : chasseHub := combat(0);
       '2' : chasseHub := combat(1);
  end;

end;

end.

