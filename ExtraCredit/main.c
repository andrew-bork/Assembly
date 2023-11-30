#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include "main.h"
#include <string.h>



void print_title() {
    printf("Product Sales Management System\n\n");
}

void print_menu() {
    printf("show - Display all sales records\nview - View an amount of a specified month\nmax - View the highest sales amount\nmin - View the lowest sales amount\nedit - Edit an amount of a specified month\ntotal - Get the total of all sales\nquit - Terminate the program\n\n");
}



void read_file(const char* filename, struct salesRecord* records) {
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        printf("Something went wrong when opening the file \"%s\" for reading.\n", filename);
        return;
    }

    for (int i = 0; i < 12; i++) {
        int n = fscanf(file, "%s\t%d\n", records[i].month, &(records[i].amount));
    }

    fclose(file);
}


void write_file(const char* filename, struct salesRecord* records) {
    FILE* file = fopen(filename, "w");
    if (file == NULL) {
        printf("Something went wrong when opening the file \"%s\" for writing.\n", filename);
        return;
    }

    for (int i = 0; i < 12; i++) {
        fprintf(file, "%s\t%d\n", records[i].month, records[i].amount);
    }

    fclose(file);
}

void save(struct salesRecord* records) {
    write_file(MONTHLY_SALES_TXT, records);
}


int main(void) {

    print_title();

    struct salesRecord records[12];

    read_file(MONTHLY_SALES_TXT, records);
    show(records);
    
    print_menu();
    int should_exit = 0;
    while (!should_exit) {

         int is_valid_command = 1;
         do {
             is_valid_command = 1;
             printf("\nCommand: ");
             char user_option[16];
             char* success = fgets(user_option, sizeof(user_option), stdin); // Warning: fgets includes the '\n' character.

             if (success == NULL) {
                 printf("Failed to read from stdin.\n");
                 continue;
             }

             if (strcmp(user_option, "show\n") == 0) {
                 show(records);
             }
             else if (strcmp(user_option, "view\n") == 0) {
                 view(records);
             }
             else if (strcmp(user_option, "max\n") == 0) {
                 max(records);
             }
             else if (strcmp(user_option, "min\n") == 0) {
                 min(records);
             }
             else if (strcmp(user_option, "edit\n") == 0) {
                 edit(records);
             }
             else if (strcmp(user_option, "total\n") == 0) {
                 total(records);
             }
             else if (strcmp(user_option, "quit\n") == 0) {
                 should_exit = 1;
             }
             else {
                 is_valid_command = 0;
                 printf("Invalid command. Try again.\n");
             }
         } while (!is_valid_command);



    };

    printf("Thanks for using my app.\n");

    return 0;
}