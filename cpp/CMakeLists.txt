cmake_minimum_required(VERSION 3.28)
project(blackjack)

set(CMAKE_CXX_STANDARD 23)

add_executable(
	blackjack main.cpp
	cards.cpp cards.hpp
	game.cpp game.hpp
	out.cpp out.hpp
)
