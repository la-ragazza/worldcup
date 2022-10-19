#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

# Insert data into teams
cat games.csv | while IFS="," read YEAR ROUND WIN OPP WINGOALS OPPGOALS
do
  if [[ $YEAR != 'year' ]]
  # Everything happens in here
  then
    # Insert team names from winners column into teams (if not in table)
    # Get winner_id for games
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")

    if [[ -z $WINNER_ID ]]
    then
      INSERT_WIN=$($PSQL "INSERT INTO teams(name) VALUES('$WIN')")
      if [[ $INSERT_WIN == "INSERT 0 1" ]]
      then
        echo Inserted into teams as winner, $WIN
      fi

      # Get new winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    fi

    # Insert team names from opponents column (if not in table)
    # Get opponent_id for games
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPP=$($PSQL "INSERT INTO teams(name) VALUES('$OPP')")
      if [[ $INSERT_OPP == "INSERT O 1" ]]
      then
        echo Inserted into teams as opponent, $OPP
      fi

      # Get new opponent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    fi

    # Insert values into games
    INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINGOALS, $OPPGOALS)")
    if [[ $INSERT_GAMES == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINGOALS, $OPPGOALS
    fi

  fi
done

# Insert data into games