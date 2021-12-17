//Unit en charge de l'équipement (arme et armures)
unit unitEquipement;
{$codepage utf8}
{$mode objfpc}{$H+}

interface        
//----- TYPES -----
type
  materiaux = (aucun,fer,Os,Ecaille);                                   //Matériaux pour les armes et armures
  emplacementArmure = (Casque,Torse,Gants,Jambieres,Bottes);            //liste des emplacements d'armures
  TArmures = array[0..4] of materiaux;                                  //Armure (5 slots)
  TCoffreArmures = array[0..4,1..ord(high(materiaux))] of boolean;      //Coffres - armures (pour chaque couple matériaux, slots, un booléen représentant si le joueur possède cet objet dans son coffre)
  TCoffreArmes = array[1..ord(high(materiaux))] of boolean;             //Coffres - armes

//----- FONCTIONS ET PROCEDURES -----
//Gestion de l'affichage (chaine de caractères) d'une pièce d'armure
function armureToString(piece : emplacementArmure; mat : materiaux) : String;
//Gestion de l'affichage (chaine de caractères) d'une arme
function armeToString(mat : materiaux) : String;    
//Renvoie le multiplicateur de dégats en fonction du matériaux de l'arme
function multiplicateurDegatsArme(mat : materiaux) : integer;     
//Renvoie l'encaissement de l'armure
function encaissement(armures : TArmures) : integer; 
//Renvoie la recette de l'objet pour affichage
function recetteToString(mat : materiaux) : string;









implementation

//Gestion de l'affichage (chaine de caractères) d'une pièce d'armure
function armureToString(piece : emplacementArmure; mat : materiaux) : String;
begin
  if(mat = aucun) then armureToString := 'Aucun'
  else
  begin
    case piece of
        Casque : armureToString := 'Casque';
        Torse : armureToString := 'Plastron';
        Gants : armureToString := 'Gants';
        Jambieres : armureToString := 'Jambieres';
        Bottes : armureToString := 'Bottes';
    end;
    case mat of
        fer : armureToString += ' en fer';
        Os : armureToString += ' en os';
        Ecaille : armureToString += ' en évaille';
    end;
  end;
end;
    
//Gestion de l'affichage (chaine de caractères) d'une arme
function armeToString(mat : materiaux) : String;
begin
   case mat of
       aucun : armeToString := 'Vos poings';
       fer : armeToString := 'Grande épée en fer';
       Os : armeToString := 'Grande épée en os'; 
       Ecaille : armeToString := 'Grande épée en écailles';
   end;
end;

//Renvoie le multiplicateur de dégats en fonction du matériaux de l'arme
function multiplicateurDegatsArme(mat : materiaux) : integer;
begin
   case mat of
       aucun : multiplicateurDegatsArme := 0;
       fer : multiplicateurDegatsArme := 1;
       Os : multiplicateurDegatsArme := 2;
       Ecaille : multiplicateurDegatsArme := 3;
   end;
end;

//Renvoie l'encaissement de l'armure
function encaissement(armures : TArmures) : integer;
var
  e : real;
  i : integer;
begin
  e:=0;
  for i:=0 to 4 do
       e += ord(armures[i])*0.5;
  encaissement := round(e);
end;

//Renvoie la recette de l'objet pour affichage
function recetteToString(mat : materiaux) : string;
begin
  case mat of
      fer : recetteToString:='(500 po)';
      os : recetteToString:='(500 po, 5 morceaux de Grand Jagras)';
      Ecaille : recetteToString:='(500 po, 5 morceaux de Pukei-Pukei)';
  end;
end;

end.

