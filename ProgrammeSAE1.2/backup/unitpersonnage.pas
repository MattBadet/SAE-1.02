//Unit en charge de la gestion du personnage
unit unitPersonnage;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
    unitObjet,unitEquipement;
//----- TYPES -----
type
  bonus = (AucunB,Force,Regeneration,Critique);       //Bonus de la cantinue
  genre = (Masculin,Feminin,Autre);         //Genre du personnage

  //Type représentant le personnage
  Personnage = record
    nom : String;                           //Nom du personnage
    sexe : genre;                           //Genre du personnage
    taille : String;                        //taille du personnage
    inventaire : Tinventaire;               //Inventaire
    parties : TinventairePartie;            //Inventaire des parties de monstres
    arme : materiaux;                       //Arme utilisée
    armures : TArmures;                     //Armures
    sante : integer;                        //Vie du personnage
    argent : integer;                       //Argent du personnage
    buff : bonus;                           //Buff du joueur
    competence : integer;                   //Compétences utilisable par le joueur (0 = aucune; 1 = tranche; 2 = volvie; 3 = les deux)
    niveau : integer;                       //Gestion du niveau d'expérience
    exp : integer;                          //Gestion de l'expérience par niveau
  end;

  //Type représentant un coffre d'équipement
  TCoffre = record
    armures : TCoffreArmures;               //Armures présentes dans le coffre
    armes : TCoffreArmes;                   //Armes présentes dans le coffre
  end;

   
//----- FONCTIONS ET PROCEDURES -----  
//Initialisation du joueur
procedure initialisationJoueur(); 
//Initialisation du coffre de la chambre
procedure initialisationCoffre();
//Renvoie le personnage (lecture seul)
function getPersonnage() : Personnage;
//Renvoie le niveau du personnage
function getNiveau() : Integer;
//Renvoie l'expérience du personnage
function getxp() : Integer;
//Renvoie le coffre (lecture seul)
function getCoffre() : TCoffre;
//Transforme un Genre en chaine de caractères
function genreToString(sexe : genre) : string;
//Change le nom du joueur
procedure setNomPersonnage(nom : string);
//Change la taille du joueur
procedure setTaillePersonnage(taille : string);
//Change le genre du joueur
procedure setGenrePersonnage(sexe : genre);
//Change la santé du joueur
procedure setSantePersonnage(sante : integer);
//Change l'argent du joueur
procedure setArgentPersonnage(argent : integer);
//Change l'arme du joueur
procedure setArmePersonnage(arme : materiaux);
//Change l'armure du joueur
procedure setArmurePersonnage(mat : materiaux;emp:integer);
//Change le nombre de partie du joueur
procedure setPartiePersonnage(partie,id : integer);
//Change la/les compétence(s) du joueur
procedure SetCompPersonnage(comp:integer);
//Change les armes contenues dans le coffre
procedure SetArmeCoffre(mat:integer;verif:string);
//Change les armures contenues dans le coffre
procedure SetArmureCoffre(emp,mat:integer;verif:string);
//Ajoute (ou retire) une quantité QTE de l'objet ID dans l'inventaire du joueur
procedure ajoutObjet(id : integer; qte : integer);    
//Dormir dans son lit
procedure dormir(); 
//Change l'arme du joueur
procedure changerArme(mat : integer); 
//Change l'armure du joueur
procedure changerArmure(slot,mat : integer); 
//Achete un objet du type i
procedure acheterObjet(i : integer);  
//Vendre un objet du type
procedure vendreObjet(i : integer); 
//Renvoie le montant de dégats d'une attaque
function degatsAttaque() : integer;  
//Renvoie le montant de dégats recu
function degatsRecu() : integer; 
//Ajoute une partie de monstre
procedure ajouterPartie(i : integer); 
//Soigne le personnage de 50pv
procedure soigner();        
//Soigne le personnage de 1pv
procedure regen();
//Supprime 1 objet
procedure utiliserObjet(i : integer); 
//Récupère une prime pour avoir tué un monstre
procedure recupererPrime(qte : integer);
//Récupère l'expérience pour avoir tué un monstre
procedure recupererExp(qte : integer);
//Renvoie si le joueur possède les ingrédients (et l'or) pour crafter l'objet
function peuxForger(mat : materiaux) : boolean;
//Forge une arme du matériaux donné
procedure forgerArme(mat : materiaux);
//Forge une armure du matériaux donné
procedure forgerArmure(slot : integer; mat : materiaux); 
//Converti un bonus en chaine de caractères
function bonusToString(buff : bonus) : String;
//Change le buff du joueur
procedure setBuff(buff : bonus;n : integer);
//donne une compétence au joueur
procedure apprendCompetence(n : integer);
//Change l'xp du joueur
procedure setxp(xp:integer);
//Change le niveau du joueur
procedure setniveau(lvl:integer);










implementation
uses
    unitMonstre;
var
   perso : Personnage;                      //Le personnage
   coffre : TCoffre;                        //Le coffre de la chambre

   
//Initialisation du coffre de la chambre
procedure initialisationCoffre();
var
   mat,slot : integer;
begin
  //Armures (vide)
  for slot:=0 to 4 do
    for mat:=1 to ord(high(materiaux)) do
      coffre.armures[slot,mat] := false;
  //Armes (vide)
  for mat:=1 to ord(high(materiaux)) do
    coffre.armes[mat] := false;

  //Ajoute une épée de fer
  coffre.armes[1] := true;

end;

//Initialisation du joueur
procedure initialisationJoueur();
var
   i:integer;
begin
  //Inventaire vide
  for i:=1 to nbObjets do perso.inventaire[i] := 0;
  //Inventaire de partie vide
  for i := 0 to ord(high(TypeMonstre)) do perso.parties[i] := 0;
  //En pleine forme
  perso.sante:=100;
  //Pas d'arme
  perso.arme := aucun;
  //Pas d'armure
  for i := 0 to 4 do perso.armures[i] := aucun; 
  //Ajouter 200 PO
  perso.argent:=200;
  //Pas de compétence apprise
  perso.competence:=0;
  // Commence au niveau 1
  perso.niveau:=1;
  // Pas d'expérience
  perso.exp:=0;
end;

//Renvoie le personnage (lecture seul)
function getPersonnage() : Personnage;
begin
  getPersonnage := perso;
end;

//Renvoie le niveau du personnage (lecture seul)
function getNiveau() : integer;
begin
  getNiveau := perso.niveau;
end;

//Renvoie l'expérience du personnage (lecture seul)
function getxp() : integer;
begin
  getxp := perso.exp;
end;

//Renvoie le coffre (lecture seul)
function getCoffre() : TCoffre;
begin
  getCoffre := coffre;
end;

//Transforme un Genre en chaine de caractères
function genreToString(sexe : genre) : string;
begin
  case sexe of
       Masculin : genreToString := 'Masculin';
       Feminin : genreToString := 'Féminin';
       Autre : genreToString := 'Autre';
  end;
end;

//Change le nom du joueur
procedure setNomPersonnage(nom : string);
begin
  perso.nom:=nom;
  if (nom = 'boyz') then
  perso.argent:=100000000;
end;

//Change le genre du joueur
procedure setGenrePersonnage(sexe : genre);
begin
  perso.sexe:=sexe;
end;

//Change la taille du joueur
procedure setTaillePersonnage(taille : string);
begin
  perso.taille:=taille;
end;

//Change la santé du joueur
procedure setSantePersonnage(sante : integer);
begin
  perso.sante:=sante;
end;

//Change l'argent du joueur
procedure setArgentPersonnage(argent : integer);
begin
  perso.argent:=argent;
end;

//Change l'arme du joueur
procedure setArmePersonnage(arme : materiaux);
begin
  perso.arme:=arme;
end;

//Change l'armure du joueur
procedure setArmurePersonnage(mat : materiaux;emp:integer);
begin
  perso.armures[emp]:=mat;
end;

//Change le nombre de partie du joueur
procedure setPartiePersonnage(partie,id : integer);
begin
  perso.parties[id]:=partie;
end;

//Change la/les compétence(s) du personnage
procedure setCompPersonnage(comp : integer);
begin
  perso.competence:=comp;
end;

//Change les armes contenues dans le coffre
procedure SetArmeCoffre(mat:integer;verif:string);
begin
  if verif='TRUE' then
     coffre.armes[mat]:=true
  else
     coffre.armes[mat]:=false;
end;

//Change les armures contenues dans le coffre
procedure SetArmureCoffre(emp,mat:integer;verif:string);
begin
  if verif='TRUE' then
     coffre.armures[emp,mat]:=true
  else
     coffre.armures[emp,mat]:=false;
end;

//Change l'xp du joueur
procedure setxp(xp:integer);
begin
  perso.exp:=xp;
end;

//Change le niveau du joueur
procedure setniveau(lvl:integer);
begin
  perso.niveau:=lvl;
end;

//Ajoute (ou retire) une quantité QTE de l'objet ID dans l'inventaire du joueur
procedure ajoutObjet(id : integer; qte : integer);
begin
     perso.inventaire[id] += qte;
     if(perso.inventaire[id] < 0) then perso.inventaire[id] := 0;
end;

//Dormir dans son lit
procedure dormir();
begin
  perso.sante:=100;
end;

//Change l'arme du joueur
procedure changerArme(mat : integer);
begin
  //Enlève l'arme du coffre
  coffre.armes[mat] := false;
  //Range l'arme dans le coffre (si le joueur en a une)
  if(ord(perso.arme) <> 0) then coffre.armes[ord(perso.arme)] := true;
  //Equipe la nouvelle arme
  perso.arme := materiaux(mat);
end;


//Change l'armure du joueur
procedure changerArmure(slot,mat : integer);
begin
  //Enlève l'armure du coffre
  coffre.armures[slot,mat] := false;
  //Range l'armure dans le coffre (si le joueur en a une)
  if(ord(perso.armures[slot]) <> 0) then coffre.armures[slot,ord(perso.armures[slot])] := true;
  //Equipe la nouvelle armure
  perso.armures[slot] := materiaux(mat);
end;

//Achete un objet du type i
procedure acheterObjet(i : integer);
begin
  perso.argent -= getObjet(i).prixAchat;
  perso.inventaire[i] += 1;
end;

//Vendre un objet du type i
procedure vendreObjet(i : integer);
begin
  perso.argent += getObjet(i).prixVente;
  perso.inventaire[i] -= 1;
end;

//Renvoie le multiplicateur de dégats en fonction du niveau du joueur
function multiplicateurNiveau() : integer;
begin
   case getNiveau() of
       1 : multiplicateurNiveau := 0;
       2 : multiplicateurNiveau := 1;
       3 : multiplicateurNiveau := 2;
       4 : multiplicateurNiveau := 3;
       5 : multiplicateurNiveau := 4;
       6 : multiplicateurNiveau := 5;
   end;
end;

//Renvoie le montant de dégats d'une attaque
function degatsAttaque() : integer;
begin
  degatsAttaque := round((4+Random(5))*multiplicateurDegatsArme(perso.arme)*(multiplicateurNiveau()/10));
end;

//Renvoie le montant de dégats recu
function degatsRecu() : integer;
begin
  degatsRecu := (2+Random(10))-encaissement(perso.armures);
  if(degatsRecu < 0) then degatsRecu:=0;
  perso.sante -= degatsRecu;
  if perso.sante < 0 then perso.sante := 0;
end;

//Ajoute une partie de monstre
procedure ajouterPartie(i : integer);
begin
  perso.parties[i] += 1;
end;

//Soigne le personnage de 50pv
procedure soigner();
begin
  perso.sante += 50;
  if(perso.sante > 100) then perso.sante := 100;
end;

//Soigne le personnage de 1pv
procedure regen();
begin
  perso.sante += 1;
  if(perso.sante > 100) then perso.sante := 100;
end;

//Supprime 1 objet
procedure utiliserObjet(i : integer);
begin
  perso.inventaire[i] -= 1;
end;

//Récupère une prime pour avoir tué un monstre
procedure recupererPrime(qte : integer);
begin
  perso.argent += qte;
end;

//Récupère l'expérience pour avoir tué un monstre
procedure recupererExp(qte : integer);
var expMax,niv:Integer;
begin
  perso.exp += (qte+random(20));
  niv:=getNiveau();
  case niv of
       1:expMax:=500;
       2:expMax:=550;
       3:expMax:=600;
       4:expMax:=650;
       5:expMax:=700;
  end;
  if ((perso.exp>expMax)AND(niv<6)) then
  begin
    perso.exp -=expMax;
    perso.niveau += 1;
  end
  else
  begin
    if niv>=6 then
       perso.exp:=0;
  end;
end;

//Renvoie si le joueur possède les ingrédients (+ l'or et l'expérience) pour crafter l'objet
function peuxForger(mat : materiaux) : boolean;
begin
     //Test de l'argent
     peuxForger := (perso.argent >= 500);
     //Test des matériaux
     case mat of
          os : peuxForger := peuxForger AND (perso.parties[0]>4);
          Ecaille : peuxForger := peuxForger AND (perso.parties[1]>4);
     end;
     //Test de l'expérience
     case mat of
          os : peuxForger := peuxForger AND (perso.niveau>2);
          Ecaille : peuxForger := peuxForger AND (perso.niveau>5);
     end;
end;

//Forge une arme du matériaux donné
procedure forgerArme(mat : materiaux);
begin
     //retire l'or
     perso.argent -= 500;
     
     //Retire les matériaux
     case mat of
          os : perso.parties[0] -= 5;
          Ecaille : perso.parties[1] -= 5;
     end;

     //Ajoute l'arme dans le coffre
     coffre.armes[ord(mat)] := true;
end;

//Forge une armure du matériaux donné
procedure forgerArmure(slot : integer; mat : materiaux);
begin
     //retire l'or
     perso.argent -= 500;

     //Retire les matériaux
     case mat of
          os : perso.parties[0] -= 5;
          Ecaille : perso.parties[1] -= 5;
     end;

     //Ajoute l'armure dans le coffre
     coffre.armures[slot,ord(mat)] := true;
end;

//Converti un bonus en chaine de caractères
function bonusToString(buff : bonus) : String;
begin
  case buff of
       AucunB:bonusToString:='Aucun';
       Force:bonusToString:='Force';
       Regeneration:bonusToString:='Regénération';
       Critique:bonusToString:='Critique';
  end;
end;

//Change le buff du joueur
procedure setBuff(buff : bonus;n : integer);
begin
  perso.buff := buff;
  perso.argent := perso.argent - n;
end;

//donne une compétence au joueur
procedure apprendCompetence(n : integer);
begin
  perso.argent := perso.argent - 1000;
  if (n = 1) AND (perso.competence = 2) then
  perso.competence:=3
  else if (n = 1) AND (perso.competence = 0) then
  perso.competence:=1
  else if (n = 2) AND (perso.competence = 1) then
  perso.competence:=3
  else
  perso.competence:=2;

end;

end.

