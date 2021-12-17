//Unit en charge de l'IHM
unit unitIHM;
{$codepage utf8}
{$mode objfpc}{$H+}

interface  
//Affiche l'interface principale (les cadres principaux)
procedure afficherInterfacePrincipale();  
//Affiche l'interface principale (les cadres principaux pour écran non split)
procedure afficherInterfaceSimple();  
//Affichage du cadre d'action
procedure afficherCadreAction();
//Affiche le nom du lieu au centre de la boite associée
procedure afficherLieu(nomLieu : string); 
//Affiche le nom du lieu au centre de la boite associée (écran simple)
procedure afficherLieuSimple(nomLieu : string);
//Positionne le curseur à la n-ième ligne de la zone d'action
procedure deplacerCurseurZoneAction(numLigne : integer); 
//Positionne le curseur à la n-ième ligne de la zone d'action
procedure deplacerCurseurZoneResponse();

implementation
uses
    unitMonstre,unitObjet,unitPersonnage,unitEquipement,GestionEcran;

//Positionne le curseur dans la zone de réponse
procedure deplacerCurseurZoneResponse();
begin
  deplacerCurseurXY(142,37);
end;

//Positionne le curseur à la n-ième ligne de la zone d'action
procedure deplacerCurseurZoneAction(numLigne : integer);
begin                
  deplacerCurseurXY(5,30+numLigne);
end;

//Affiche le nom du lieu au centre de la boite associée (écran split)
procedure afficherLieu(nomLieu : string);
begin
   deplacerCurseurXY(74-(length(nomLieu)div 2),2);
   write(nomLieu);
end;

//Affiche le nom du lieu au centre de la boite associée (écran simple)
procedure afficherLieuSimple(nomLieu : string);
begin
   deplacerCurseurXY(99-(length(nomLieu)div 2),2);
   write(nomLieu);
end;

//Affichage du cadre extérieur de l'IHM
procedure afficherCadreExterieur();
begin 
  dessinerCadreXY(1,0,198,39,simple,white,black);
end;

//Affichage du cadre d'action
procedure afficherCadreAction();
begin
  dessinerCadreXY(1,29,198,39,simple,white,black);
end;

//Affichage du cadre de réponse
procedure afficherCadreResponse();
begin
  dessinerCadreXY(139,36,145,38,simple,white,black);
end;

//Affichage le cadre latéral du personnage
procedure afficherMenuLateralPersonnage();
var
  i:integer;
begin
  dessinerCadreXY(147,0,198,39,simple,white,black);
  dessinerCadreXY(156,0,190,2,simple,white,black);
  dessinerCadreXY(158,1,188,3,simple,white,black);
  deplacerCurseurXY(164,2);Write('FICHE DU PERSONNAGE');

  if(getPersonnage().Nom <> '') then
  begin
    deplacerCurseurXY(164,5);Write('   -------------   ');

    deplacerCurseurXY(155,7); write('       Nom : ',getPersonnage().nom);
    deplacerCurseurXY(155,8); write('     Genre : ',genreToString(getPersonnage().sexe));
    deplacerCurseurXY(155,9); write('    Taille : ',getPersonnage().taille);

    deplacerCurseurXY(164,11);Write('   -------------   ');

    deplacerCurseurXY(155,13); write('     Santé : ',getPersonnage().sante);
    deplacerCurseurXY(155,14); write('    Argent : ',getPersonnage().argent);


    deplacerCurseurXY(164,16);Write('   -------------   ');

    deplacerCurseurXY(155,18); write('      Arme : ',armeToString(getPersonnage().arme));
    deplacerCurseurXY(155,19); write('    Casque : ',armureToString(Casque,getPersonnage().armures[0]));
    deplacerCurseurXY(155,20); write('     Torse : ',armureToString(Torse,getPersonnage().armures[1]));
    deplacerCurseurXY(155,21); write('     Gants : ',armureToString(Gants,getPersonnage().armures[2]));
    deplacerCurseurXY(155,22); write(' Jambières : ',armureToString(Jambieres,getPersonnage().armures[3]));
    deplacerCurseurXY(155,23); write('    Bottes : ',armureToString(Bottes,getPersonnage().armures[4]));

    deplacerCurseurXY(164,25);Write('   -------------   ');
    for i:=0 to ord(high(TypeMonstre)) do
    begin
        deplacerCurseurXY(180-length(partieToString(TypeMonstre(i))),27+i);
        write(partieToString(TypeMonstre(i)),' : ',getPersonnage().parties[i]);
    end; 
    deplacerCurseurXY(164,30);Write('   -------------   '); 
    deplacerCurseurXY(155,32);Write('      Buff : ',bonusToString(getPersonnage().buff));

  end;

end;

//Affichage le cadre du lieu dans le cas d'un écran simple
procedure afficherCadreLieuEcranSimple();
begin   
  dessinerCadreXY(48,0,151,2,simple,white,black);
  dessinerCadreXY(54,1,146,3,simple,white,black);
end;

//Affichage le cadre du lieu dans le cas d'un écran split
procedure afficherCadreLieuEcranSplit();
begin
  dessinerCadreXY(23,0,125,2,simple,white,black);
  dessinerCadreXY(29,1,119,3,simple,white,black);
end;

//Affiche l'interface principale (les cadres principaux pour écran split)
procedure afficherInterfacePrincipale();
begin
  effacerEcran;  
  //Cadre extérieur
  afficherCadreExterieur();
  //Cadre action
  afficherCadreAction();
  //Cadre réponse
  afficherCadreResponse();
  //Cadre latéral droit
  afficherMenuLateralPersonnage();
  //Cadre Lieu
  afficherCadreLieuEcranSplit();
end;
                    
//Affiche l'interface principale (les cadres principaux pour écran non split)
procedure afficherInterfaceSimple();
begin
  effacerEcran;
  //Cadre extérieur
  afficherCadreExterieur();
  //Cadre action
  afficherCadreAction(); 
  //Cadre Lieu
  afficherCadreLieuEcranSimple();
end;

end.

