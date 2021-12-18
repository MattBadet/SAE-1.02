//Programme principal du jeu Monster Hunter : New World
program MonsterHunter;

uses UnitLieu, unitIHM, unitPersonnage, unitObjet, unitChambre, unitEquipement,
  unitVille, unitMarchand, unitMonstre, unitChasse, unitCantine, unitForge;

var lieuEnCours : typeLieu;  //Lieu où se trouve le "joueur"

begin
  //Randomize
  Randomize;
  //Le programme commence au niveau du menu principal
  LieuEnCours := menuPrincipal;
  //Tant que l'utilisateur ne souhaite pas quitter
  while LieuEnCours <> quitter do
  begin
    //On se rend au lieu en cours (dans lequel l'utilisateur spécifira un nouveau lieu en cours)
    LieuEnCours := seRendre(LieuEnCours);
  end;
end.

