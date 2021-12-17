//Unité en charge de la gestion des lieux
//Unit en charge de la gestion des lieux
unit UnitLieu;   
{$codepage utf8}
{$mode objfpc}{$H+}

interface
//----- TYPES -----
type
    //Les différents lieux principaux
    typeLieu = (quitter,menuPrincipal,creationPersonnage,chambreArrivee,chambre,ville,forge,marchand,cantine,expedition);

//----- FONCTIONS ET PROCEDURES -----
//Déplace le joueur dans le nouveau lieu et exécute le code associé à ce lieu.
//Renvoie le prochain lieu à visiter (déterminé par le code du lieu)
function seRendre(destination : typeLieu) : typeLieu;














implementation
uses
    UnitCantine,UnitForge,UnitChasse,UnitMenuPrincipal,unitChambre,unitVille,unitMarchand;

//----- VARIABLES -----
var
  lieuCourant : typeLieu;           //Lieu où se trouve le joueur
  lieuPrecedant : typeLieu;         //Lieu où se trouvait le joueur


//----- FONCTIONS ET PROCEDURES -----

//Déplace le joueur dans le nouveau lieu et exécute le code associé à ce lieu.
//Renvoie le prochain lieu à visiter (déterminé par le code du lieu)
function seRendre(destination : typeLieu) : typeLieu;
begin
     //Le lieu actuel devient le lieu précédant
     lieuPrecedant := lieuCourant;
     //Changement du lieu courant
     lieuCourant := destination;
     //Exécution de la procédure associé
     case lieuCourant of
          menuPrincipal: seRendre:=menuPrincipalHub();                //Menu principal
          creationPersonnage: seRendre:=creationPersonnageHub();      //Création du personnage
          chambreArrivee: seRendre:=chambrePremiereFois();            //Premère arrivée dans la chambre
          chambre : seRendre:=chambreHub();                           //Chambre
          ville : seRendre:=villeHub();                               //Place principale de la ville
          marchand : seRendre:=marchandHub();                         //Place du marcher
          expedition : seRendre:=chasseHub();                         //Porte de la ville
          forge : seRendre:=ForgeHUB();                               //Forge
          cantine : seRendre:=cantineHUB();                           //Cantine
     end;
end;

end.

