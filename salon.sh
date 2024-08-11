#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c "

echo -e "\n ~~~~~ BEYSTAT SALON ~~~~~ "

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "WELCOME, PLEASE CHOOSE A SERVICE\n"
  SER1=$($PSQL "SELECT * FROM services")
  echo "$SER1" | while read SERVICE_ID BAR NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
  
  SECOND_MENU

}
SECOND_MENU(){
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "Please choose a service"
  else
    SERVICE_AVAILABLE=$($PSQL "SELECT service_id FROM services WHERE service_id= $SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_AVAILABLE ]]
    then
      MAIN_MENU "Please choose a service"
    fi
    echo -e "What's your phone number?"
    read CUSTOMER_PHONE
    GETS_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $GETS_NAME ]]
    then
      echo -e "\nWhat's your name, we do not have a record of you\n"
      read CUSTOMER_NAME
      INSERT_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

    fi
    GET_NAME=$($PSQL "SELECT name FROM customers WHERE phone ='$CUSTOMER_PHONE'")
    GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone ='$CUSTOMER_PHONE'")
    SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id= $SERVICE_ID_SELECTED")
    echo what time do yo want a $CUSTOMER_NAME $SERVICE_ID
    read SERVICE_TIME
    INSERT_APPOINT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME',$GET_CUSTOMER_ID, $SERVICE_ID_SELECTED)")
    echo I have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $GET_NAME.

  fi
}
MAIN_MENU