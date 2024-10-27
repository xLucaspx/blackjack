#pragma once

#include <unordered_map>
#include "cards.hpp"

#define HIT_OP 1
#define STAND_OP 2
#define PLAY_OP 1
#define QUIT_OP 2
#define DEALER_LIMIT 17
#define MAX_HAND_SIZE 9

/**
 * Randomly draws a card with a value ranging from `1` to `13` (included). As in a real
 * deck of cards, only 4 of each card can be drawn; the `drawnCards` map passed as an
 * argument keeps track of the already drawn cards and the function checks it to guarantee
 * that the drawn card is valid. If the card is valid, it is added to the `drawnCards` map,
 * as well as to the vector of cards passed as an argument, representing a hand of cards of
 * one of the players.
 *
 * @param drawnCards Map that keeps track of the cards drawn throughout the game; will be
 *                   updated with the drawn card.
 * @param hand       Hand of cards of the player drawing in the round; the drawn card will
 *                   be added to this vector.
 * @return The card drawn.
 */
short drawCard(std::unordered_map<short, short>& drawnCards, std::vector<short>& hand);

/**
 * Operates the first deal of cards of the game; the player and the dealer receive a total of
 * two cards each, one card at a time for the player and the dealer, respectively.
 *
 * @param drawnCards Map that keeps track of the cards drawn throughout the game; will be
 *                   updated with the cards drawn.
 * @param player     Vector of cards representing the player's hand; will be updated with the
 *                   cards drawn.
 * @param dealer     Vector of cards representing the dealer's hand; will be updated with the
 *                   cards drawn.
 */
void deal(std::unordered_map<short, short>& drawnCards, std::vector<short>& player, std::vector<short>& dealer);

/**
 * Runs a round of the blackjack game. Calls `deal` to deal the cards, prints the game status and
 * proceeds to call `playerRound` and `dealerRound`; the latter one will only be called if the
 * player's total points is less than or equal to 21. Computes the winner, informs the player and
 * calls on `resetGame` before ending execution.
 *
 * @param drawnCards Map that keeps track of the cards drawn throughout the game; it's expected to be
 *                   empty, and it will be cleared at the end of the execution.
 * @param player     Vector of cards representing the player's hand; it's expected to be empty, and it
 *                   will be cleared at the end of the execution.
 * @param dealer     Vector of cards representing the dealer's hand; it's expected to be empty, and it
 *                   will be cleared at the end of the execution.
 */
void blackjack(std::unordered_map<short, short>& drawnCards, std::vector<short>& player, std::vector<short>& dealer);

/**
 * Computes the player's points based on his cards and, while possible, asks if he wants to hit
 * or stand. If the player hits, a new card is drawn and the execution begins again; if the total
 * points are greater than or equal to 21, the function stops executing.
 *
 * @param drawnCards Map that keeps track of the cards drawn throughout the game; will be updated with the
 *                   cards drawn.
 * @param player     Vector of cards representing the player's hand; will be updated with the cards drawn.
 * @return The player's total points after his turn ends.
 */
int playerRound(std::unordered_map<short, short>& drawnCards, std::vector<short>& player);

/**
 * Computes the dealer's points based on his cards and, while they're lesser than the limit defined in
 * the `DEALER_LIMIT` constant, the dealer hits and a new card is drawn. When the total points are greater
 * than or equal to the limit, the function stops executing.
 *
 * @param drawnCards Map that keeps track of the cards drawn throughout the game; will be updated with the
 *                   cards drawn.
 * @param dealer     Vector of cards representing the dealer's hand; will be updated with the cards drawn.
 * @return The dealer's total points after his turn ends.
 */
int dealerRound(std::unordered_map<short, short>& drawnCards, std::vector<short>& dealer);

/**
 * Clears the structures used to represent the game, without modifying their capacity.
 *
 * @param drawnCards Map that keeps track of the cards drawn throughout the game.
 * @param player     Vector of cards representing the player's hand.
 * @param dealer     Vector of cards representing the dealer's hand.
 */
void resetGame(std::unordered_map<short, short>& drawnCards, std::vector<short>& player, std::vector<short>& dealer);

/**
 * Initializes the data structures needed for running the game, reserves memory and calls the
 * appropriate methods. Will run until the user stops the execution or inputs an invalid option.
 */
void run();
