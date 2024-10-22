#pragma once

#include <string>
#include <vector>

/**
 * Computes the total points corresponding to the cards passed as argument,
 * with respect to the following rules:
 * - Cards from 2 to 10 are computed with their respective value;
 * - Cards with value greater than 10 are computed with value 10;
 * - If the card has value 1 and the current sum is less than or equal to 10,
 *   the computed value is 11; otherwise, the computed value is 1.
 *
 * @param cards The cards from which to calculate the points.
 * @return The total points corresponding to the cards.
 */
int sum(const std::vector<short>& cards);

/**
 * Returns the symbol that corresponds to the value of the card passed as an
 * argument, with respect to the following rules:
 * - Cards from 2 to 10 have the same symbol as their value;
 * - The value 1 corresponds to the symbol "A";
 * - The value 11 corresponds to the symbol "J";
 * - The value 12 corresponds to the symbol "Q";
 * - The value 13 corresponds to the symbol "K".
 *
 * @param value The value of the card from which to obtain the symbol.
 * @return The symbol corresponding to the value.
 */
std::string getCardSymbol(const short& value);
