
#include "plasma.h"
// #define GRAVITY 0.5
// #define JUMP_IMPULSE 10


#define GROUND_Y 360
#define GRAVITY 1
#define JUMP_FORCE 15
#define MAX_JUMP_COUNT 2
#define MAX_JUMP_COUNT_BOT 1
#define MAX_JUMP_COUNT_BALL 1
#define X_LIMIT 590
#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480
#define false 0
#define true 1

#define DELAY_MS 10 // Délai en millisecondes entre chaque mise à jour de la position verticale





#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480


#define true 1
#define false 0


typedef int bool;


int putchar(int value);
int puts(const char *string);




 void SEG7(char E4, char E3, char E2, char E1);
 void delay (int ms);
 void VGA_SPRITE(int x, int y);
 void VGA_SPRITE2(int x, int y);
 void VGA_SPRITE3(int x, int y);
 void VGA_SPRITE4(int ball_x, int ball_y);
 void VGA_SPRITE5(int x, int y);
 void VGA_SPRITE6(int x, int y);
 void VGA_SPRITE7(int x, int y);
 
 
 
 void VGA_COLOR(int value);
 int SW(void);
 void Led(int value);
 char *itoa10(unsigned long num);
int BTN_R(void);
 int BTN_L(void);
 int BTN_U(void);
 int BTN_D(void);
 
 
int difference(int a, int b) 
{
    int diff = a - b;
	return diff;
}

int main(void)
{
	

    int x = 580;
    int y = GROUND_Y;
	int x_w=45;
	int y_h=45;
	int res=0;
	int x_bot=10;
	int y_bot=GROUND_Y;
	int bot_dx=1;
	int tir_bot=0;
	
	int i=0;
    int y_velocity = 0;
	int ball_velocity=0;
	int ball_velocity_bot=0;
    int jump_count = 0;
	int jump_count_ball=0;
	int jump_count_ball_bot=0;
    bool jumping = false;
	bool up_button_released = true; // Indique si le bouton "up" a été relâché
	bool down_button_released =false; 
	bool falling = false;
	bool jump_allowed= true;
	bool jump_allowed_bot = true;
	bool falling_bot = false;
	bool contact_bot=false;
	bool shoot_bot= false;

	

	int tir_x=0;
	int niveau=0;
	bool contact= false;
	int i_contact=0;
	int x_dx=5;
	int ind=0;
	int k=0;
	int j=0;
	int test=0;
	int ball_x = 200;
	int ball_w = 35;
	int ball_h=35;
	int ball_y = 320;
	int ball_dx = 2;
	int une_fois = 1;
	int plus_contact=0;
	int tir=0;
	int tir_dx=17;
	VGA_SPRITE4(200,360);
 	VGA_SPRITE5(800,800);
	VGA_SPRITE6(800,800); 
	VGA_SPRITE7(220,165);
	while(BTN_D()==0)
	{}
	VGA_SPRITE7(-300,-300);
	
    while (1)
    {
			
		SEG7(k,0,0,j);

			if(BTN_U())
			{			
				if (up_button_released && jump_count < MAX_JUMP_COUNT) //&& jump_timer==0)
				{
					// Si le bouton U est enfoncé et le personnage peut encore effectuer un saut
					y_velocity = -JUMP_FORCE;
					jumping = true;
					jump_count++;
					//jump_timer= JUMP_DELAY;
				}
				up_button_released = false;
			}	
			else 
			{
				up_button_released = true;
			}
			


			 if (jumping )
			 {
				// Mettre à jour la position verticale en fonction de la vélocité
				y += y_velocity;

				// Limiter la position verticale à la zone visible de l'écran
				if (y < 0)
				{
					y = 0;
				}

				// Mettre à jour la vélocité verticale pour simuler la gravité
				if (y < GROUND_Y)
				{
					y_velocity += GRAVITY;
				}
				else
				{
					y_velocity = 0;
				}	

				if (BTN_R())
				{
					if (x!=590)
					{
					// Si le bouton R est enfoncé et le personnage est en train de sauter
						x += 5; // Changer la valeur selon votre besoin
					}
				}
				

				if (BTN_L())
				{
					// Si le bouton L est enfoncé, le personnage est au sol et en train de sauter
					if (x!=0)
					{
						x -= 5; // Changer la valeur selon votre besoin
					}
				}



				// Vérifier si le personnage a atteint le sol
				if (y >= GROUND_Y)
				{
					y = GROUND_Y;  // Réinitialiser la position verticale au sol
					y_velocity = 0;
					jumping = false;
					jump_count = 0;
				}

			 }


		
			else
			{
				 if(BTN_L())
					 x-=x_dx;
					 y=GROUND_Y;

				 if(BTN_R())
					 x+=x_dx;
				
				if(x>=590)
					x=X_LIMIT;
				if(x<=0)
					x=0;
			}	
		
		/////////////////////////////Ballon
		
		
			if(BTN_D())
			{
				down_button_released=true;
			}
			else
			{
				down_button_released=false;
			}
			
			

			if(((ball_x+ball_w)>=x+15 && ball_x<=(x+x_w))  && ((ball_y+ball_h)>=y && ball_y<=(y+y_h)))
			{
				if(tir==0)
					contact = true;
			}
			else 
				contact=false;
			

		// Pour controler le ballon avec le personnage
		
			if (BTN_L())
			{
				if(ball_x!=0)	
					if(contact && (tir == 0) && ball_y ==GROUND_Y)
					{
						ball_x-=5;	
					}
			}		
			
			if(BTN_R())
			{
				if(ball_x!=580)
					 if(contact && (tir == 0) && ball_y ==GROUND_Y)
					 {
						ball_x+=5;
					 }
			}	

				
				
			//ball_x+=2*ball_dx;

			if (ball_x <= 0 || ball_x + ball_w >= 640) {
			 ball_dx = -ball_dx;  // Inverser la direction horizontale de la balle
			 }
			 
			
			 if(contact)
				 ind = 1; // la balle est à l'intérieur du perso
			else{
				 ind = 0;
				 une_fois = 1;
			 }
			
			if((ind == 1)&&(une_fois==1)){
				//ball_velocity= -JUMP_FORCE;
				ball_dx = - ball_dx;
				test=1;
				//falling=true;
				une_fois =0;
			}
			
			
			if(SW()==1)
				tir_x=1;
			else
				tir_x=0;
			
			 
			if (tir_x==0 && down_button_released && (((ball_x+ball_w)>=x+5 && ball_x<=(x+x_w))  && ((ball_y+ball_h)>=y && ball_y<=(y+y_h))) &&jump_allowed&& jump_count_ball < MAX_JUMP_COUNT_BALL)
			{
					// Si le bouton U est enfoncé et le personnage peut encore effectuer un saut
				ball_velocity = -JUMP_FORCE;
				falling = true;
				jump_count_ball++;
				plus_contact=1;
				tir=1;
			}
			else if (tir_x==1 && down_button_released)
				ball_x-=20;
				

			if(tir==1)
			{
				contact=false;
				if(ball_x<=x)
				{
					ball_x-=tir_dx;
				}
				else 
					ball_x+=tir_dx;
				if(tir_dx>0)
				{
					tir_dx--;
				}
				else
				{
					tir=0;
					tir_dx=17;
				}
			}


			if(falling)
			{
			
				// Mettre à jour la position verticale en fonction de la vélocité
				ball_y += ball_velocity;
			
				// Limiter la position verticale à la zone visible de l'écran
				if (ball_y < 0)
				{
					ball_y = 0;
				}
				// Mettre à jour la vélocité verticale pour simuler la gravité
				if (ball_y < GROUND_Y)
				{
					ball_velocity += GRAVITY;
				}
				else
				{
					ball_velocity = 0;
				}	
				
				if(BTN_R())
				{
					if(ball_x!=590)
						ball_x+=5;
				}
				
				if (BTN_L())
				{
					// Si le bouton L est enfoncé, le personnage est au sol et en train de sauter
					if (ball_x!=0)
					{
						ball_x -= 5; // Changer la valeur selon votre besoin
					}
				}

				
				if (ball_y >= GROUND_Y)
				{
					ball_y = GROUND_Y;  // Réinitialiser la position verticale au sol
					ball_velocity = 0;
					falling  = false;
					jump_count_ball=0;
				}
			}

	 



			
			 ball_y+=ball_velocity;
			 ball_velocity+=GRAVITY;
			
			if(ball_y >= GROUND_Y || ball_y + ball_h>= 480)
			{
				 ball_y=GROUND_Y;
				 ball_velocity=0;
				 falling=false;
			}
			 
			 
			 

			 
			 
			 if(ball_x>=x+5)
				jump_allowed= false;
			 else 
			 {
				 jump_allowed= true;
			 }		
		 
			 
			 
			 
			if (ball_x+ball_w>620 )
			{
				k++;
				res=1;
			}
			
			
			
			if(ball_x<30)
			{
				j++;
				niveau+=2;
				res=1;
			}


			
			if(k==5)
			{
				VGA_SPRITE(580,GROUND_Y);
				VGA_SPRITE2(10,GROUND_Y);
				VGA_SPRITE5(245,165);
				while(BTN_D()==0)
				{}
				VGA_SPRITE5(-300,-300);			
				k=0;
				j=0;
				niveau=0;
			}
		
			
			if(j==5)
			{		
				VGA_SPRITE(580,GROUND_Y);
				VGA_SPRITE2(10,GROUND_Y);
				VGA_SPRITE6(220,165);
				while(BTN_D()==0)		
				{}
				VGA_SPRITE6(-300,-300);
				j=0;
				k=0;
				niveau=0;
			}


			if (res==1)
			{
				SEG7(k,0,0,j);
				ball_x=300;
				x=580;
				x_bot=30;
				VGA_SPRITE4(ball_x,ball_y);
				VGA_SPRITE(x,y);
				VGA_SPRITE2(x_bot,y_bot);
				res=0;
				tir=0;
			}
			



	///////// PARTIE BOT //////////////////////






			if(((ball_x+ball_w)>=x_bot+15 && ball_x<=(x_bot+x_w))  && ((ball_y+ball_h)>=y_bot && ball_y<=(y_bot+y_h)))
			{
				if(tir_bot==0)
					contact_bot = true;
			}
			else 
				contact_bot=false;
			







		
			if(difference(x_bot,ball_x)>0 && i_contact==0)
			{
				if(niveau==0)
					bot_dx=-2;
				else if(niveau!=0)
					bot_dx=-(2+niveau);
			}
				
			else if(difference(x_bot,ball_x)<0 && i_contact==0)
			{
				if(niveau==0)
					bot_dx=2;
				else if(niveau!=0)
					bot_dx=2+niveau;
			}

			if(contact_bot)
			{	
				ball_x+=5;
				if(niveau!=0)
					ball_x+=(5+niveau);
			}	


				
		
			
			
			x_bot+=bot_dx;
			
			if(x_bot>=590)
				x_bot=X_LIMIT;
			else if(x_bot<=0)
				x_bot=0;
			
				



			if(difference(x_bot,350)==0)
			{
				shoot_bot= true;
			}
			else
			{
				shoot_bot=false;
			}

			 
			if ((((ball_x+ball_w)>=x_bot+5 && ball_x<=(x_bot+x_w))  && ((ball_y+ball_h)>=y_bot && ball_y<=(y_bot+y_h))) && shoot_bot &&jump_allowed_bot&& jump_count_ball_bot < MAX_JUMP_COUNT_BALL)
			{
					//Si le bouton U est enfoncé et le personnage peut encore effectuer un saut
				ball_velocity_bot = -JUMP_FORCE;
				falling_bot = true;
				jump_count_ball_bot++;
			}

	 

			if(falling_bot)
			{
			
				//Mettre à jour la position verticale en fonction de la vélocité
				ball_y += ball_velocity;
			
				//Limiter la position verticale à la zone visible de l'écran
				if (ball_y < 0)
				{
					ball_y = 0;
				}
				//Mettre à jour la vélocité verticale pour simuler la gravité
				if (ball_y < GROUND_Y)
				{
					ball_velocity += GRAVITY;
				}
				else
				{
					ball_velocity = 0;
				}	
				

				
				if (ball_y >= GROUND_Y)
				{
					ball_y = GROUND_Y;  // Réinitialiser la position verticale au sol
					ball_velocity = 0;
					falling_bot  = false;
					jump_count_ball_bot=0;
				}
			}


			 if(ball_x<=x_bot+30)
				jump_allowed_bot= false;
			 else 
			 {
				 jump_allowed_bot= true;
			 }		
		 
			
			
			
			
			if(difference(x+x_w,x_bot)==0)
			{
				VGA_SPRITE(x,y);
				VGA_SPRITE2(x_bot,y_bot);
				
			}
		
		
			VGA_SPRITE(x, y);
			VGA_SPRITE2(x_bot,y_bot);
			VGA_SPRITE4(ball_x,ball_y);
			delay(30);
			// puts(itoa10(j));
			// puts("\n");
	}
  
}


//// export PATH=/home/Dias-Coelho/gccmips_elf/:$PATH	