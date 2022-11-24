#! /bin/bash

if [[ $1 == "test" ]]
then
  #PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
  PSQL="psql --username=orfeo --dbname=worldcuptest -t --no-align -c"
else
  #PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
  PSQL="psql --username=orfeo --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND HOME AWAY WINNER OPO
do
  if [[ $HOME != winner ]]
  then
    # Valida si el equipo local ya existe
    TEAM_HOME=$($PSQL "SELECT name FROM teams WHERE name = '$HOME'")
    if [[ -z $TEAM_HOME ]]
    then
      #insert team home
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$HOME')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into team home, $HOME
      fi
    fi

    #Valida si el equipo visitante ya existe
    TEAM_AWAY=$($PSQL "SELECT name FROM teams WHERE name = '$AWAY'")
    if [[ -z $TEAM_AWAY ]]
    then
      # Insert team away
      INSERT_TEAM_AWAY_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$AWAY')")
      if [[ $INSERT_TEAM_AWAY_RESULT == 'INSERT 0 1' ]]
      then 
        echo Inserted into team away, $AWAY
      fi
    fi

    #search id team home
    TEAM_ID_HOME=$($PSQL "SELECT team_id FROM teams WHERE name = '$HOME'")
    #search id team away
    TEAM_ID_AWAY=$($PSQL "SELECT team_id FROM teams WHERE name = '$AWAY'")
    #Insert all data table games
    INSERT_GAMES=$($PSQL "INSERT INTO games(year,round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR','$ROUND','$TEAM_ID_HOME','$TEAM_ID_AWAY','$WINNER','$OPO') ")
    if [[ $INSERT_GAMES == 'INSERT 0 1' ]]
    then
      echo Inserted into game, $YEAR $ROUND $HOME $AWAY
    fi
  fi
done 


