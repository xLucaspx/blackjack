#include "cards.hpp"

int sum(const std::vector<short>& cards)
{
	// The type int is the "natural size" for the target system.
	// Integer types that are smaller than int are promoted to int in
	// arithmetic expressions so that the processor can be most efficient.
	int total = 0;
	short aceCount = 0;
	for (short value: cards) {
		if (value >= 10) {
			total += 10; // 10, J, Q, K are worth 10
			continue;
		}
		if (value == 1) {
			aceCount++; // count aces separately
			continue;
		}
		total += value; // cards 2-9 are added directly
	}

	for (short i = 0; i < aceCount; i++) {
		total += (total <= 10 ? 11 : 1); // maximize use of aces as 11 without exceeding 21
	}

	return total;
}

std::string getCardSymbol(const short& value)
{
	if (value > 1 && value < 10) {
		return std::to_string(value);
	}

	switch (value) {
		case 1:
			return "A";
		case 10:
			return "10";
		case 11:
			return "J";
		case 12:
			return "Q";
		case 13:
			return "K";
		default:
			return "Valor inválido!";
	}
}
