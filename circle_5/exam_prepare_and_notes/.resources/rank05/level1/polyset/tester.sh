# #!/bin/bash

# # Color codes for output
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# BLUE='\033[0;34m'
# NC='\033[0m' # No Color

# # Comprehensive Test Script for polyset
# echo -e "${BLUE}🔍 Running COMPREHENSIVE TESTING for polyset${NC}"
# echo "=========================================="
# echo ""

# # Copy subject skeleton files if they exist
# if [ -d "subject" ]; then
#     cp subject/*.hpp . 2>/dev/null || true
#     cp subject/*.cpp . 2>/dev/null || true
# fi

# echo -e "${BLUE}📦 Compiling reference solution...${NC}"
# g++ -Wall -Wextra -Werror -std=c++11 -o ref_polyset main.cpp $(ls *.cpp 2>/dev/null | grep -v '^main\.cpp$')

# if [ $? -ne 0 ]; then
#     echo -e "${RED}❌ Reference compilation failed!${NC}"
#     exit 1
# fi

# echo -e "${GREEN}✅ Reference compilation successful!${NC}"
# echo ""


# USER_DIR="../../../../rendu/polyset"
# if [ ! -d "$USER_DIR" ]; then
#     echo -e "${RED}❌ User solution folder not found: $USER_DIR${NC}"
#     exit 1
# fi


# echo -e "${BLUE}📦 Compiling user solution...${NC}"
# # Copy user files with different names to avoid overwriting template skeleton
# cp main.cpp user_main.cpp
# for f in $USER_DIR/*.cpp; do
#     [ -f "$f" ] && cp "$f" "user_$(basename "$f")"
# done
# for f in $USER_DIR/*.hpp; do
#     [ -f "$f" ] && cp "$f" "user_$(basename "$f")"
# done
# # Copy subject files for user build
# if [ -d "subject" ]; then
#     cp subject/*.hpp . 2>/dev/null || true
#     cp subject/*.cpp . 2>/dev/null || true
# fi
# g++ -Wall -Wextra -Werror -std=c++11 -o user_polyset user_main.cpp user_*.cpp $(ls *.cpp 2>/dev/null | grep -v '^main\.cpp$' | grep -v '^user_')
# if [ $? -ne 0 ]; then
#     echo -e "${RED}❌ User compilation failed!${NC}"
#     exit 1
# fi

# echo -e "${GREEN}✅ User compilation successful!${NC}"
# echo ""

# # Run both and capture output
# echo -e "${BLUE}🚀 Running tests...${NC}"
# ./ref_polyset > ref_output.txt 2>&1
# echo "[DEBUG] Reference output:"; cat ref_output.txt
# ./user_polyset > user_output.txt 2>&1
# echo "[DEBUG] User output:"; cat user_output.txt

# # Compare outputs
# output_match=true
# output_error_msg=""
# if diff -q ref_output.txt user_output.txt > /dev/null; then
#     echo -e "${GREEN}✅ Output matches reference!${NC}"
# else
#     echo -e "${RED}❌ Output does NOT match reference!${NC}"
#     echo -e "${YELLOW}--- Reference Output ---${NC}"
#     cat ref_output.txt
#     echo -e "${YELLOW}--- Your Output ---${NC}"
#     cat user_output.txt
#     echo -e "${YELLOW}--- Diff ---${NC}"
#     diff ref_output.txt user_output.txt
#     output_match=false
#     output_error_msg="Output does not match reference solution."
# fi

# # Run with valgrind for memory leak checking
# echo -e "${BLUE}🚀 Executing valgrind analysis...${NC}"
# echo "Command: valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes -s ./user_polyset"
# echo ""

# # Capture valgrind output to analyze
# valgrind_output=$(valgrind \
#     --leak-check=full \
#     --show-leak-kinds=all \
#     --track-origins=yes \
#     -s \
#     --error-exitcode=1 \
#     ./user_polyset 2>&1)

# exit_code=$?

# # Display the full output
# echo "$valgrind_output"

# echo ""
# echo -e "${BLUE}🏁 Valgrind analysis completed with exit code: $exit_code${NC}"
# echo ""

# # Parse and analyze the output
# echo "======================================="
# echo -e "${YELLOW}📊 DETAILED ANALYSIS RESULTS:${NC}"
# echo "======================================="

# # Check for memory leaks
# has_leaks=false
# if echo "$valgrind_output" | grep -q "definitely lost:" && echo "$valgrind_output" | grep "definitely lost:" | grep -v "0 bytes"; then
#     has_leaks=true
# fi
# if echo "$valgrind_output" | grep -q "indirectly lost:" && echo "$valgrind_output" | grep "indirectly lost:" | grep -v "0 bytes"; then
#     has_leaks=true
# fi
# if echo "$valgrind_output" | grep -q "possibly lost:" && echo "$valgrind_output" | grep "possibly lost:" | grep -v "0 bytes"; then
#     has_leaks=true
# fi

# # Check for errors
# has_errors=false
# if echo "$valgrind_output" | grep -q "ERROR SUMMARY" && echo "$valgrind_output" | grep "ERROR SUMMARY" | grep -v "0 errors"; then
#     has_errors=true
# fi

# # Display results with color coding
# echo -n "Memory Leaks: "
# if [ "$has_leaks" = true ]; then
#     echo -e "${RED}DETECTED - You have memory leaks!${NC}"
# else
#     echo -e "${GREEN}PASSED - No memory leaks detected${NC}"
# fi

# echo -n "Valgrind Errors: "
# if [ "$has_errors" = true ]; then
#     echo -e "${RED}DETECTED - Valgrind found errors!${NC}"
# else
#     echo -e "${GREEN}PASSED - No valgrind errors${NC}"
# fi

# echo ""
# echo "======================================="
# echo -n "OVERALL RESULT: "
# if [ "$has_leaks" = false ] && [ "$has_errors" = false ] && [ "$output_match" = true ]; then
#     echo -e "${GREEN}✅ ALL TESTS PASSED!${NC}"
#     echo -e "${GREEN}Your polyset implementation is clean!${NC}"
# else
#     echo -e "${RED}❌ ISSUES DETECTED!${NC}"
#     echo -e "${YELLOW}Summary of errors:${NC}"
#     if [ "$has_leaks" = true ]; then
#         echo -e "${RED}  → Memory leaks detected.${NC}"
#     fi
#     if [ "$has_errors" = true ]; then
#         echo -e "${RED}  → Valgrind errors detected.${NC}"
#     fi
#     if [ "$output_match" = false ]; then
#         echo -e "${RED}  → Output does not match reference solution.${NC}"
#     fi
# fi
# echo "======================================="

# # Wait for user to press enter before continuing
# # Wait for user to press enter before continuing
# read -rp "Press enter to continue..." dummy

# # Cleanup temporary files
# rm -f ref_polyset user_polyset ref_output.txt user_output.txt
# rm -f user_main.cpp user_*.cpp user_*.hpp
# # Remove subject files that were copied
# rm -f bag.hpp array_bag.cpp array_bag.hpp tree_bag.cpp tree_bag.hpp searchable_bag.hpp
#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Comprehensive Test Script for polyset
echo -e "${BLUE}🔍 Running COMPREHENSIVE TESTING for polyset${NC}"
echo "=========================================="
echo ""

# Copy subject skeleton files if they exist
if [ -d "subject" ]; then
    cp subject/*.hpp . 2>/dev/null || true
    cp subject/*.cpp . 2>/dev/null || true
fi

echo -e "${BLUE}📦 Compiling reference solution...${NC}"
g++ -Wall -Wextra -Werror -std=c++11 -o ref_polyset main.cpp searchable_array_bag.cpp searchable_tree_bag.cpp set.cpp array_bag.cpp tree_bag.cpp

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Reference compilation failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Reference compilation successful!${NC}"
echo ""


USER_DIR="../../../../rendu/polyset"
if [ ! -d "$USER_DIR" ]; then
    echo -e "${RED}❌ User solution folder not found: $USER_DIR${NC}"
    exit 1
fi


echo -e "${BLUE}📦 Compiling user solution...${NC}"
# Copy user files with different names to avoid overwriting template skeleton
cp main.cpp user_main.cpp
cp "$USER_DIR/searchable_array_bag.cpp" user_searchable_array_bag.cpp 2>/dev/null
cp "$USER_DIR/searchable_array_bag.hpp" user_searchable_array_bag.hpp 2>/dev/null
cp "$USER_DIR/searchable_tree_bag.cpp" user_searchable_tree_bag.cpp 2>/dev/null
cp "$USER_DIR/searchable_tree_bag.hpp" user_searchable_tree_bag.hpp 2>/dev/null
cp "$USER_DIR/set.cpp" user_set.cpp 2>/dev/null
cp "$USER_DIR/set.hpp" user_set.hpp 2>/dev/null

g++ -Wall -Wextra -Werror -std=c++11 -o user_polyset user_main.cpp user_searchable_array_bag.cpp user_searchable_tree_bag.cpp user_set.cpp array_bag.cpp tree_bag.cpp

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ User compilation failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ User compilation successful!${NC}"
echo ""

# Run both and capture output
echo -e "${BLUE}🚀 Running tests...${NC}"
./ref_polyset > ref_output.txt 2>&1
./user_polyset > user_output.txt 2>&1

# Compare outputs
output_match=true
if diff -q ref_output.txt user_output.txt > /dev/null; then
    echo -e "${GREEN}✅ Output matches reference!${NC}"
else
    echo -e "${RED}❌ Output does NOT match reference!${NC}"
    echo -e "${YELLOW}--- Reference Output ---${NC}"
    cat ref_output.txt
    echo -e "${YELLOW}--- Your Output ---${NC}"
    cat user_output.txt
    echo -e "${YELLOW}--- Diff ---${NC}"
    diff ref_output.txt user_output.txt
    output_match=false
fi

# Run with valgrind
echo -e "${BLUE}🚀 Executing valgrind analysis...${NC}"
valgrind_output=$(valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes -s --error-exitcode=1 ./user_polyset 2>&1)
exit_code=$?
echo "$valgrind_output"
echo ""
echo -e "${BLUE}🏁 Valgrind analysis completed with exit code: $exit_code${NC}"
echo ""

# Analyze valgrind output
has_leaks=false
if echo "$valgrind_output" | grep -q "definitely lost:" && echo "$valgrind_output" | grep "definitely lost:" | grep -v "0 bytes"; then
    has_leaks=true
fi
if echo "$valgrind_output" | grep -q "indirectly lost:" && echo "$valgrind_output" | grep "indirectly lost:" | grep -v "0 bytes"; then
    has_leaks=true
fi

has_errors=false
if echo "$valgrind_output" | grep -q "ERROR SUMMARY" && echo "$valgrind_output" | grep "ERROR SUMMARY" | grep -v "0 errors"; then
    has_errors=true
fi

echo "======================================="
echo -e "${YELLOW}📊 DETAILED ANALYSIS RESULTS:${NC}"
echo "======================================="
echo -n "Memory Leaks: "
if [ "$has_leaks" = true ]; then
    echo -e "${RED}DETECTED${NC}"
else
    echo -e "${GREEN}PASSED${NC}"
fi

echo -n "Valgrind Errors: "
if [ "$has_errors" = true ]; then
    echo -e "${RED}DETECTED${NC}"
else
    echo -e "${GREEN}PASSED${NC}"
fi

echo ""
echo -n "OVERALL RESULT: "
if [ "$has_leaks" = false ] && [ "$has_errors" = false ] && [ "$output_match" = true ]; then
    echo -e "${GREEN}✅ ALL TESTS PASSED!${NC}"
else
    echo -e "${RED}❌ ISSUES DETECTED!${NC}"
fi
echo "======================================="

read -rp "Press enter to continue..." dummy

# Cleanup - DELETE ONLY user files and subject files, KEEP template skeleton
rm -f ref_polyset user_polyset ref_output.txt user_output.txt
rm -f user_main.cpp user_searchable_array_bag.cpp user_searchable_array_bag.hpp user_searchable_tree_bag.cpp user_searchable_tree_bag.hpp user_set.cpp user_set.hpp
rm -f bag.hpp array_bag.cpp array_bag.hpp tree_bag.cpp tree_bag.hpp searchable_bag.hpp