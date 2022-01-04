//Unit en charge du menu principal et de l'écran de création du personnage
unit UnitMenuPrincipal;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  UnitLieu;

//----- FONCTIONS ET PROCEDURES -----
//Fonction exécutée à l'arrivée dans le menu principale
//Renvoie le prochain lieu à visiter
function menuPrincipalHub() : typeLieu; 
//Fonction exécutée à l'arrivée dans l'écran de création du personnage
//Renoive le prochain lieu à visiter
function creationPersonnageHub() : typeLieu;
function chargerpartie():typeLieu;













implementation
uses
  unitMonstre,unitASCII,unitIHM,GestionEcran,unitPersonnage,unitObjet,unitEquipement,Sysutils;


//----- FONCTIONS ET PROCEDURES -----

//Fonction exécutée à l'arrivée dans le menu principale
//Renvoie le prochain lieu à visiter
function menuPrincipalHub() : typeLieu;
var
  choix : String;            //Choix du joueur au menu
begin
   //Ecran du logo
   afficherLogo();
   readln;
   //Menu principal
   afficherInterfacePrincipale();
   afficherTitreMenuPrincipal();
   afficherLieu('Menu Principal');
   if FileExists('save.txt') then
   begin
     deplacerCurseurZoneAction(2);write('1/ Débuter une nouvelle partie');
     deplacerCurseurZoneAction(4);write('2/ Continuer la partie');
     deplacerCurseurZoneAction(6);write('3/ Quitter');
     deplacerCurseurZoneResponse();
     readln(choix);
     case choix of
          '1': menuPrincipalHub:=creationPersonnage;
          '2': menuPrincipalHub:=chargerpartie;
           else menuPrincipalHub:=quitter;
     end;
   end
   else
   begin
     deplacerCurseurZoneAction(2);write('1/ Débuter une nouvelle partie');
     deplacerCurseurZoneAction(6);write('3/ Quitter');
     deplacerCurseurZoneResponse();
     readln(choix);
     case choix of
          '1': menuPrincipalHub:=creationPersonnage;
           else menuPrincipalHub:=quitter;
     end;
   end

end;

//Fonction exécutée à l'arrivée dans l'écran de création du personnage
//Renoive le prochain lieu à visiter
function creationPersonnageHub() : typeLieu;
var
   nom : string;           //Nom saisi par l'utilisateur
   taille : string;        //taille saisi par l'utilisateur
   sexe : string;          //sexe du personnage
begin
     //Initialisation
     initialisationJoueur();
     initialisationCoffre();
     initialisationObjets();
     initialisationMonstres();

     afficherInterfaceSimple();
     afficherLieuSimple('Création du personnage');

     deplacerCurseurXY(55,7);write('Voilà plusieurs jours que l''Amazone a pris la mer avec une partie de la cinquième compagnie');
     deplacerCurseurXY(55,8);write('à son bord. L''excitation du départ a maintenant laissé place à la routine et la lassitude.');

     deplacerCurseurXY(55,10);write('Vous vous trouvez sur le pont, regardant l''océan, s''étendant à perte de vue, espérant y voir');
     deplacerCurseurXY(55,11);write('apparaitre votre destination : l''ile mystérieuse d''Aeternum.');

     deplacerCurseurXY(55,13);write('Alors que vous errez dans vos pensées, un homme au visage dissimulé derrière un masque de mé');
     deplacerCurseurXY(55,14);write('tal s''approche de vous.');

     couleurTexte(Cyan);
     deplacerCurseurXY(55,16);write('"Nous devrions être dans vue d''Aeternum d''ici quelques heures... Vous m''avez l''air bien impa');
     deplacerCurseurXY(55,17);write('tient de rejoindre la terre ferme. Vous devez faire partie de la sixième compagnie ! Nous');
     deplacerCurseurXY(55,18);write('n''avons pas encore eu l''occasion de nous rencontrer. Je m''appelle Markus Wulfhart, capitaine');
     deplacerCurseurXY(55,19);write('de l''Amazone !"');
          
     couleurTexte(White);

     //Nom du personnage
     deplacerCurseurZoneAction(2);write('Comment vous appelez-vous ? ');
     readln(nom);
     setNomPersonnage(nom);

     //Taille du personnage
     deplacerCurseurZoneAction(4);write('Quelle est votre taille (en cm) ? ');
     readln(taille);
     setTaillePersonnage(taille);

     //Genre du personnage
     deplacerCurseurZoneAction(6);write('Etes-vous :   (1) un homme    (2) une femme    (3) autre');
     deplacerCurseurZoneAction(7);
     readln(sexe);
     case sexe of
          '1' : setGenrePersonnage(Masculin);
          '2' : setGenrePersonnage(Feminin);
          else setGenrePersonnage(Autre);
     end;

     afficherCadreAction();

     couleurTexte(lightred);
     deplacerCurseurXY(55,21);write('"Bonjour capitaine, je m''appelle '+getPersonnage().nom+ '!"');
                           
     couleurTexte(white);
     deplacerCurseurXY(55,23);write('Alors que le capitaine et vous commencez à échanger quelques banalités, le ciel se couvre');
     deplacerCurseurXY(55,24);write('brutalement. En quelques secondes à peine, la mer, jusque-là calme, se transforme un monstre');
     deplacerCurseurXY(55,25);write('rugissant. Le bateau tangue violemment vous projetant contre une paroie. Vous sentez votre');
     deplacerCurseurXY(55,26);write('tête heurter celle-ci violemment et le monde autour de vous disparaît.');
     readln;

     creationPersonnageHub:=chambreArrivee;
end;
function chargerpartie(): typeLieu;
var
   savefile: TextFile;
   taille,nom : string;
   qte,pv,po,partie1,partie2,comp : integer;
   sexe : genre;
   arm,casque,torse,gants,jambieres,bottes : materiaux;
   buf:bonus;
   epeefer,epeeos,epeeecaille:string;
   casquefer,casqueos,casqueecaille:string;
   torsefer,torseos,torseecaille:string;
   gantsfer,gantsos,gantsecaille:string;
   jambieresfer,jambieresos,jambieresecaille:string;
   bottesfer,bottesos,bottesecaille:string;

begin
     //Initialisation
     initialisationJoueur();
     initialisationCoffre();
     initialisationObjets();
     initialisationMonstres();

     AssignFile(savefile, 'save.txt');
     Reset(savefile);
     Readln(savefile, nom);
     setNomPersonnage(nom);
     Readln(savefile,taille);
     setTaillePersonnage(taille);
     Readln(savefile,sexe);
     setGenrePersonnage(sexe);
     Readln(savefile,pv);
     setSantePersonnage(pv);
     Readln(savefile,po);
     setArgentPersonnage(po);
     Readln(savefile,arm);
     setArmePersonnage(arm);
     Readln(savefile,casque);
     setArmurePersonnage(casque,0);
     Readln(savefile,torse);
     setArmurePersonnage(torse,1);
     Readln(savefile,gants);
     setArmurePersonnage(gants,2);
     Readln(savefile,jambieres);
     setArmurePersonnage(jambieres,3);
     Readln(savefile,bottes);
     setArmurePersonnage(bottes,4);
     Readln(savefile,partie1);
     setPartiePersonnage(partie1,0);
     Readln(savefile,partie2);
     setPartiePersonnage(partie2,1);
     Readln(savefile,buf);
     setBuff(buf,0);
     Readln(savefile,comp);
     SetCompPersonnage(comp);
     //ARME
     Readln(savefile,epeefer);
     setArmeCoffre(1,epeefer);
     Readln(savefile,epeeos);
     setArmeCoffre(2,epeeos);
     Readln(savefile,epeeecaille);
     setArmeCoffre(3,epeeecaille);
     //ARMURE
     Readln(savefile,casquefer);
     SetArmureCoffre(0,1,casquefer);
     Readln(savefile,torsefer);
     SetArmureCoffre(1,1,torsefer);
     Readln(savefile,gantsfer);
     SetArmureCoffre(2,1,gantsfer);
     Readln(savefile,jambieresfer);
     SetArmureCoffre(3,1,jambieresfer);
     Readln(savefile,bottesfer);
     SetArmureCoffre(4,1,bottesfer);
     Readln(savefile,casqueos);
     SetArmureCoffre(0,2,casqueos);
     Readln(savefile,torseos);
     SetArmureCoffre(1,2,torseos);
     Readln(savefile,gantsos);
     SetArmureCoffre(2,2,gantsos);
     Readln(savefile,jambieresos);
     SetArmureCoffre(3,2,jambieresos);
     Readln(savefile,bottesos);
     SetArmureCoffre(4,2,bottesos) ;
     Readln(savefile,casqueecaille);
     SetArmureCoffre(0,3,casqueecaille);
     Readln(savefile,torseecaille);
     SetArmureCoffre(1,3,torseecaille);
     Readln(savefile,gantsecaille);
     SetArmureCoffre(2,3,gantsecaille);
     Readln(savefile,jambieresecaille);
     SetArmureCoffre(3,3,jambieresecaille);
     Readln(savefile,bottesecaille);
     SetArmureCoffre(4,3,bottesecaille);
     //OBJET
     Readln(savefile,qte);
     ajoutObjet(1,qte);
     Readln(savefile,qte);
     ajoutObjet(2,qte);
     //XP
     Readln(savefile,xp);
     setXp(xp);
     Readln(savefile,lvl);
     setNiveau(lvl);

     CloseFile(savefile);

     chargerpartie:=chambre;
end;

end.

