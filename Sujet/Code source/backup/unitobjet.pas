//Unit en charge des objets (hors armures et armes) et partie de monstres
unit unitObjet;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
    unitMonstre;
//----- CONSTANTES -----
const
  nbObjets = 2;                   //Nombre de types d'objets existants


//----- TYPES -----
type
  //Type représentant un objet
  objet = record
    id : integer;                 //Id de l'objet (unique)
    nom : string;                 //Nom de l'objet
    prixAchat : integer;          //Prix à l'achat
    prixVente : integer;          //Prix à la vente
  end;

  TcatalogueObjet = array[1..nbObjets] of objet;                               //Tableau d'objets
  Tinventaire = array[1..nbObjets] of integer;                                 //Inventaire
  TinventairePartie = array[0..ord(high(TypeMonstre))] of integer;             //Inventaire de parties de monstres

//----- FONCTIONS ET PROCEDURES ----- 
//Initialisation du catalogue des objets
procedure initialisationObjets();
//Renvoie l'objet d'id donné (lecture seule)
function getObjet(id : integer) : objet; 
//Gestion de l'affichage des parties de monstre
function partieToString(tm : TypeMonstre) : String;









implementation
var
   catalogueObjets : TcatalogueObjet;             //Catalogue de tous les objets

//Initialisation du catalogue des objets
procedure initialisationObjets();
begin
     //Potion
     catalogueObjets[0].id:=1;
     catalogueObjets[0].nom:='Potion';
     catalogueObjets[0].prixAchat:=100;
     catalogueObjets[0].prixVente:=50;
     //Potion
     catalogueObjets[1].id:=2;
     catalogueObjets[1].nom:='Bombe';
     catalogueObjets[1].prixAchat:=30;
     catalogueObjets[1].prixVente:=15;
end;

//Renvoie l'objet d'id donné (lecture seule)
function getObjet(id : integer) : objet;
begin
    getObjet := catalogueObjets[id];
end;

//Gestion de l'affichage des parties de monstre
function partieToString(tm : TypeMonstre) : String;
begin
     partieToString := 'Morceau de '+nomMonstre(tm);
end;

end.

