#include "out.hpp"

/**
 * Prints all the cards from hand of cards with the `+` symbol between them,
 * and then prints `=` the amount of points passed as argument.
 *
 * @param hand Cards to be printed.
 * @param points Sum of points corresponding to the cards.
 */
void printHand(const std::vector<short>& hand, const short& points);

void printGameStart(const std::vector<short>& player, const short& dealer)
{
	std::cout << std::endl << "The player is dealt: " << getCardSymbol(player[0])
						<< " and " << getCardSymbol(player[1]) << std::endl;
	std::cout << "The dealer reveals: " << getCardSymbol(dealer) << " and a hidden card" << std::endl;
}

void printDealtCardPlayer(const short& drawnCard)
{
	std::cout << std::endl << "The player is dealt: " << getCardSymbol(drawnCard);
}

void printDealtCardDealer(const short& drawnCard)
{
	std::cout << std::endl << "The dealer must continue to hit cards..." << std::endl;
	std::cout << "The dealer is dealt: " << getCardSymbol(drawnCard);
}

void printWinner(const short& playerPoints, const short& dealerPoints)
{
	std::cout << std::endl;
	if (playerPoints > 21) {
		std::cout << "The player has burst! The dealer wins!";
	} else if (dealerPoints > 21) {
		std::cout << "The dealer has burst! You win!";
	} else if (playerPoints > dealerPoints) {
		std::cout << "You win with " << playerPoints << " points!";
	} else if (playerPoints < dealerPoints) {
		std::cout << "The dealer wins with " << dealerPoints << " points!";
	} else {
		std::cout << "The game is tied at " << playerPoints << " points!";
	}
	std::cout << std::endl;
}


void printPlayerHand(const std::vector<short>& hand, const short& points)
{
	std::cout << std::endl << "Your hand: ";
	printHand(hand, points);
}

void printDealerHand(const std::vector<short>& hand, const short& points)
{
	std::cout << std::endl << "The dealer has: ";
	printHand(hand, points);
}

void revealDealerHand(const std::vector<short>& hand, const short& points)
{
	std::cout << std::endl << "The dealer reveals his hand: ";
	printHand(hand, points);
}

void printHand(const std::vector<short>& hand, const short& points)
{
	int size = hand.size();

	for (int i = 0; i < size; i++) {
		std::cout << getCardSymbol(hand[i]) << (i == size - 1 ? "" : " + ");
	}

	std::cout << " = " << points << std::endl;
}
