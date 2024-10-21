EXE=Blackjack
OBJECTS= main.cpp cards.cpp game.cpp out.cpp
CC=g++
FLAGS=-std=c++23

$(EXE): $(OBJECTS)
	$(CC) $(FLAGS) $(OBJECTS) -o $(EXE)

%.o: %.cpp
	$(CC) $(FLAGS) -c $< -o $@
