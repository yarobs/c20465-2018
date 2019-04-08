/*
* Created by yarob on 8/18/18.
*/


#include <stddef.h>
#include "data.h"

void append_data(data **head, data *d){
    data *tmp;
    if (*head == NULL) {
        *head = d;
        return;
    }
    for (tmp = *head; tmp->next != NULL; tmp = tmp->next);
    tmp->next = d;
}

void push_data (data **head, data *d) {
    if (*head == NULL) {
        *head = d;
    } else {
        d->next = *head;
        *head = d;
    }
}
