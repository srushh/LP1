#include <omp.h>
#include <stdio.h>
#include <iostream>
#include <ctime>
#include <stdlib.h>
#include <algorithm>

#define SIZE 10

using namespace std;

class Node
{
public:
  int val;
  Node* left;
  Node* right;
  Node(int val)
  {
    this->val = val;
    this->left = NULL;
    this->right = NULL;
  }
};

void parallel_dfs(Node* temp)
{
  if(temp == NULL)
    return;
   #pragma opm parallel sections
   {
      #pragma opm section
      {
         parallel_dfs(temp->left);
      }
      cout<<temp->val<<"->";
      #pragma opm section
      {
         parallel_dfs(temp->right);
      }
   }
}
void dfs(Node* temp)
{
  if(temp == NULL)
    return;

    dfs(temp->left);
    cout<<temp->val;
    dfs(temp->right);
}


int main()
{
  int* a = new int[SIZE];
  for(int i=0;i<SIZE;i++)
  {
    a[i] = i+1;
  }
  
  Node* root=NULL,*curr = NULL;
  
  if(root == NULL)
  {
    Node* new1 = new Node(a[0]);
    root = new1;
  }
  for(int i=1;i<SIZE-1;i++)
  {
    Node* temp = root;
    Node* new1 = new Node(a[i]);
    while(temp != NULL)
    {
        if(temp->val > a[i])
        {
            if(temp->left!=NULL)
              temp = temp->left;
            else
            {
              temp->left=new1;
              break;
            }
        }
        else
        {
          if(temp->right!=NULL)
              temp = temp->right;
            else
            {
              temp->right=new1;
              break;
            }
              
        }
    }
    
 

  }
      clock_t time = clock();
      parallel_dfs(root);
      cout<<endl;
      cout<<(float)(clock()-time)/(CLOCKS_PER_SEC)<<endl;
      time = clock();
      dfs(root);
      cout<<endl;
      cout<<(float)(clock()-time)/(CLOCKS_PER_SEC)<<endl;


  
}


