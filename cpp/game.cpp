#include <random>
#include "game.hpp"
#include "out.hpp"

short drawCard(std::map<short, short>& drawnCards, std::vector<short>& hand)
{
	// uses a `random_device` once to seed the random number generator (`mt`)
	std::random_device rd;
	std::mt19937 mt(rd());
	std::uniform_int_distribution<short> dist(1, 13);
	short card = dist(mt);

	while (drawnCards[card] >= 4) {
		card = dist(mt);
	}
	drawnCards[card]++;
	hand.emplace_back(card);
	return card;
}

void deal(std::map<short, short>& drawnCards, std::vector<short>& player, std::vector<short>& dealer)
{
	for (int i = 0; i < 4; i++) {
		if (i & 1) {
			drawCard(drawnCards, dealer);
		} else {
			drawCard(drawnCards, player);
		}
	}
}

void blackjack(std::map<short, short>& drawnCards, std::vector<short>& player, std::vector<short>& dealer)
{
	deal(drawnCards, player, dealer);
	printGameStart(player, dealer[0]);

	short playerPoints = playerRound(drawnCards, player);

	if (playerPoints > 21) {
		printWinner(playerPoints, sum(dealer));
		resetGame(drawnCards, player, dealer);
		return;
	}

	short dealerPoints = dealerRound(drawnCards, dealer);
	printWinner(playerPoints, dealerPoints);
	resetGame(drawnCards, player, dealer);
}

short playerRound(std::map<short, short>& drawnCards, std::vector<short>& player)
{
	short playerPoints = sum(player);
	printPlayerHand(player, playerPoints);
	int op = HIT_OP;

	while (op == HIT_OP && playerPoints < 21) {
		printPlayerMove();
		std::cin >> op;

		if (op != HIT_OP) {
			break;
		}

		short card = drawCard(drawnCards, player);
		printDealtCardPlayer(card);
		playerPoints = sum(player);
		printPlayerHand(player, playerPoints);

		if (playerPoints > 21) {
			break;
		}
	}
	return playerPoints;
}

short dealerRound(std::map<short, short>& drawnCards, std::vector<short>& dealer)
{
	short dealerPoints = sum(dealer);
	revealDealerHand(dealer, dealerPoints);

	while (dealerPoints < DEALER_LIMIT) {
		short card = drawCard(drawnCards, dealer);
		printDealtCardDealer(card);
		dealerPoints = sum(dealer);
		printDealerHand(dealer, dealerPoints);
	}

	return dealerPoints;
}

void resetGame(std::map<short, short>& drawnCards, std::vector<short>& player, std::vector<short>& dealer)
{
	player.clear();
	dealer.clear();
	drawnCards.clear();
}

void run()
{
	std::map<short, short> drawnCards;
	std::vector<short> playerCards;
	std::vector<short> dealerCards;
	playerCards.reserve(MAX_HAND_SIZE);
	dealerCards.reserve(MAX_HAND_SIZE);

	printHeader();
	bool run;

	do {
		blackjack(drawnCards, playerCards, dealerCards);
		printEndMenu();
		int op;
		std::cin >> op;
		run = op == PLAY_OP;
	} while (run);

	std::cout << std::endl << "game over" << std::endl;
}