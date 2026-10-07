PRAGMA foreign_keys = ON;

CREATE TABLE Contexte (
                ID_Contexte INTEGER NOT NULL,
                Saison VARCHAR(9) NOT NULL,
                Competition VARCHAR(100) NOT NULL,
                Libelle_Contexte VARCHAR(50) NOT NULL,
                CONSTRAINT PK_Contexte PRIMARY KEY (ID_Contexte)
);


CREATE TABLE Equipe (
                ID_Equipe INTEGER NOT NULL,
                Equipe VARCHAR(50) NOT NULL,
                CONSTRAINT PK_Equipe PRIMARY KEY (ID_Equipe),
	        CONSTRAINT UQ_Equipe UNIQUE (Equipe)
);


CREATE TABLE Position (
                ID_Position VARCHAR(4) NOT NULL,
                Position VARCHAR(50) NOT NULL,
                CONSTRAINT PK_Position PRIMARY KEY (ID_Position)
);


CREATE TABLE Joueurs (
                ID_Joueur INTEGER NOT NULL,
                Pos_Principale VARCHAR(4) NOT NULL,
                Joueur VARCHAR(50) NOT NULL,
                Nation VARCHAR(7) NOT NULL,
                Annee_Naissance INTEGER NOT NULL,
                Mouvement_durant_saison VARCHAR(100) NOT NULL,
                CONSTRAINT PK_Joueurs PRIMARY KEY (ID_Joueur),
                CONSTRAINT Position_Joueurs_fk
                  FOREIGN KEY (Pos_Principale)
                  REFERENCES Position (ID_Position),
				CONSTRAINT CK_Joueurs_Pos_Principale
                  CHECK (Pos_Principale IN ('AT','DF','MT','GB'))
);


CREATE TABLE Statistiques_Joueur (
                ID_Joueur INTEGER NOT NULL,
                ID_Contexte INTEGER NOT NULL,
                ID_Equipe INTEGER NOT NULL,
                Matchs_Jouer INTEGER NOT NULL,
                Titulaire INTEGER NOT NULL,
                Minutes_Jouer INTEGER NOT NULL,
                Equivalent_Matchs_90min REAL NOT NULL,
                Buts INTEGER NOT NULL,
                Passes_decisives INTEGER NOT NULL,
                Buts_plus_passes_decisives INTEGER NOT NULL,
                Buts_hors_penalty INTEGER NOT NULL,
                Penaltys_marques INTEGER NOT NULL,
                Penaltys_tentes INTEGER NOT NULL,
                Cartons_jaunes INTEGER NOT NULL,
                Cartons_rouges INTEGER NOT NULL,
                Buts_attendus REAL NOT NULL,
                Buts_attendus_hors_penalty REAL NOT NULL,
                Buts_assistes_attendus REAL NOT NULL,
                But_attendus_hors_penalty_plus_assistes REAL NOT NULL,
                Conduites_progressives INTEGER NOT NULL,
                Passes_progressives INTEGER NOT NULL,
                Passes_progressives_recues INTEGER NOT NULL,
                CONSTRAINT PK_Statistiques_Joueur PRIMARY KEY (ID_Joueur, ID_Contexte, ID_Equipe),
				CONSTRAINT Joueurs_Statistiques_Joueur_fk
                  FOREIGN KEY (ID_Joueur)
                  REFERENCES Joueurs (ID_Joueur),
				CONSTRAINT Contexte_Statistiques_Joueur_fk
                  FOREIGN KEY (ID_Contexte)
                  REFERENCES Contexte (ID_Contexte),
				CONSTRAINT Equipe_Statistiques_Joueur_fk
                  FOREIGN KEY (ID_Equipe)
                  REFERENCES Equipe (ID_Equipe), 
				CONSTRAINT CK_Statistiques_Joueur_Temps
                 CHECK (
                    Matchs_Jouer >= 0
                    AND Titulaire >= 0
                    AND Minutes_Jouer >= 0
                    AND Equivalent_Matchs_90min >= 0
                    AND Titulaire <= Matchs_Jouer
               ),
			    CONSTRAINT CK_Statistiques_Joueur_Performance
                 CHECK (
                     Buts >= 0
                     AND Passes_decisives >= 0
                     AND Buts_plus_passes_decisives >= 0
                     AND Buts_hors_penalty >= 0
                     AND Penaltys_marques >= 0
                     AND Penaltys_tentes >= 0
                     AND Cartons_jaunes >= 0
                     AND Cartons_rouges >= 0
                     AND Buts_plus_passes_decisives = Buts + Passes_decisives
                     AND Buts_hors_penalty = Buts - Penaltys_marques
                     AND Penaltys_marques <= Penaltys_tentes
    ),
	            CONSTRAINT CK_Statistiques_Joueur_Attendu
                 CHECK (
                     Buts_attendus >= 0
                     AND Buts_attendus_hors_penalty >= 0
                     AND Buts_assistes_attendus >= 0
                     AND But_attendus_hors_penalty_plus_assistes >= 0
                     AND Buts_attendus_hors_penalty <= Buts_attendus
    ),
	            CONSTRAINT CK_Statistiques_Joueur_Progression
                 CHECK (
                    Conduites_progressives >= 0
                    AND Passes_progressives >= 0
                    AND Passes_progressives_recues >= 0
    )
);               


CREATE TABLE Salaire (
                ID_Joueur INTEGER NOT NULL,
                ID_Contexte INTEGER NOT NULL,
                Salaires_annuels INTEGER NOT NULL,
                Notes VARCHAR(255) NOT NULL,
                CONSTRAINT PK_Salaire PRIMARY KEY (ID_Joueur, ID_Contexte),
                CONSTRAINT Joueurs_Salaire_fk
                  FOREIGN KEY (ID_Joueur)
                  REFERENCES Joueurs (ID_Joueur),
                CONSTRAINT Contexte_Salaire_fk
                  FOREIGN KEY (ID_Contexte)
                  REFERENCES Contexte (ID_Contexte),
				CONSTRAINT CK_Salaire_Positif
                  CHECK (Salaires_annuels > 0)
);



