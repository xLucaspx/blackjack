#pragma once

#include <iostream>
#include "cards.hpp"
#include "game.hpp"

/**
 * Prints the game header.
 */
inline void printHeader()
{
	std::cout << "     ._______." << std::endl;
	std::cout << "     |K o  WW|   ._________________________________________." << std::endl;
	std::cout << "     | o.o {)|   |   ^     ^                     _    _ _  |" << std::endl;
	std::cout << " .___|___. %%|   |  / \\  /   \\                  (.)  ( V ) |" << std::endl;
	std::cout << " |A  ^   |%%%|   | ( . ) \\   /  [ Blackjack ]  (_._)  \\ /  |" << std::endl;
	std::cout << " |  /.\\  |__>|   |   |     v                     |     v   |" << std::endl;
	std::cout << " | (_._) |       *-----------------------------------------*" << std::endl;
	std::cout << " |   |   |" << std::endl;
	std::cout << " |______V|" << std::endl;
}

/**
 * Prints a message asking the user to input whether he will hit or stand,
 * informing the code corresponding to each option.
 */
inline void printPlayerMove()
{
	std::cout << "What do you wish to do? (" << HIT_OP << " - Hit, " << STAND_OP << " - Stand): ";
}

/**
 * Prints a message asking the user to input whether he will play again or not,
 * informing the code corresponding to each option.
 */
inline void printEndMenu()
{
	std::cout << std::endl << "Do you want to play again? (" << PLAY_OP << " - Yes, " << QUIT_OP << " - No): ";
}

/**
 * Prints a message informing the player's drawn card on the round.
 *
 * @param drawnCard The value that represents the drawn card.
 */
void printDealtCardPlayer(const short& drawnCard);

/**
 * Prints a message informing the dealer's drawn card on the round.
 *
 * @param drawnCard The value that represents the drawn card.
 */
void printDealtCardDealer(const short& drawnCard);

/**
 * Computes the winner of the round based on the points passed as arguments
 * and prints a message accordingly.
 *
 * @param playerPoints The total player points on the round .
 * @param dealerPoints The total dealer points on the round.
 */
void printWinner(const int& playerPoints, const int& dealerPoints);

/**
 * Prints the state of the game when the cards are first dealt.
 *
 * @param player The player hand, both cards will be printed.
 * @param dealer The one card from the dealer hand that will be revealed.
 */
void printGameStart(const std::vector<short>& player, const short& dealer);


/**
 * Prints all the player's cards and the sum of his points.
 *
 * @param hand The player's cards.
 * @param points The player's total points.
 */
void printPlayerHand(const std::vector<short>& hand, const int& points);

/**
 * Prints all the dealer's cards and the sum of his points.
 *
 * @param hand The dealer's cards.
 * @param points The dealer's total points.
 */
void printDealerHand(const std::vector<short>& hand, const int& points);

/**
 * Reveals all the dealer's cards and the sum of his points. It's basically the same as
 * `printPlayerHand` but with a slightly different message; should be called only when
 * the player stands and the dealer begins to draw cards.
 *
 * @param hand The dealer's cards.
 * @param points The dealer's total points.
 */
void revealDealerHand(const std::vector<short>& hand, const int& points);
