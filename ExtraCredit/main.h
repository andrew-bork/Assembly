#pragma once

#define MONTHLY_SALES_TXT "monthly_sales.txt"

#define MONTH_SIZE 4
#define LINE_SIZE 20
#define COMMAND_SIZE 6

struct salesRecord {
    char month[MONTH_SIZE];
    int amount;
};

int main(void);

void print_title(void);
void print_menu(void);
void read_file(const char* filename, struct salesRecord* records);
void write_file(const char* filename, struct salesRecord* records);

// This just calls write_file(MONTHLY_SALES_TXT, records);
void save(struct salesRecord* records);


int get_amount();

void show(struct salesRecord* records);
void view(struct salesRecord* records);
void max(struct salesRecord* records);
void min(struct salesRecord* records);
void edit(struct salesRecord* records);
void total(struct salesRecord* records);