JsOsaDAS1.001.00bplist00�Vscripto2 / /   t o   r u n   i n   T e r m i n a l : 
 / /   %   c d   / U s e r s / p r o t o o l s / D e s k t o p / t e s t S c r i p t s 
 / /   %   o s a s c r i p t   - l   J a v a S c r i p t   j x a R e n a m e L a s t T r a c k . s c p t   f o o   b a r 
 / /   u s e   ' A c c e s s i b i l i t y   I n s p e c t o r '   t o   d e t e r m i n e   U I   h i e r a r c h y ,   n a m e s   o f   e l e m e n t s 
 
 O b j C . i m p o r t ( " F o u n d a t i o n " ) ; 
     
 c o n s t   a r g s   =   $ . N S P r o c e s s I n f o . p r o c e s s I n f o . a r g u m e n t s ; 
 / /   f r o m   c o n s o l e : 
 / /   a r g s [ 0 . . 3 ]   a r e   f i l e n a m e ,   " / u s r / b i n / o s a s c r i p t " ,   " - l " ,   " J a v a S c r i p t "   
 / /   f r o m   o s a S c r i p t   i n   o u r   p r o g r a m : 
 / /   @ " / u s r / b i n / o s a s c r i p t , / U s e r s / p r o t o o l s / L i b r a r y / S c r i p t s / j x a R e n a m e L a s t T r a c k . s c p t , f o o b a r " 	 0 x 0 0 0 0 6 0 0 0 0 1 e b b b a 0 
 / / c o n s o l e . l o g ( " a r g s . c o u n t " , a r g s . c o u n t ) ; 	 / /   n o t e   ' c o u n t ' ,   O b j e c t i v e   C - l i k e   
 
 v a r   a r g v   =   [ ] ; 
 v a r   r e s u l t   =   ' \ t - 1 \ t e r r o r \ t ' ; 	 / /   a s s u m e   f a i l u r e 
 
 i f   ( a r g s . c o u n t   >   1 ) { 
 
 	 v a r   s t a r t I n d e x   =   a r g s . j s [ 1 ] . j s   = =   ( ' - l ' )   ?   4   :   2 ; 	 / /   a s s u m e   w e   a r e   c a l l e d   f r o m   t h e   c o m m a n d   l i n e 
 
 	 / / c o n s o l e . l o g ( ' s t a r t I n d e x ' ,   s t a r t I n d e x ) ; 
 
 	 f o r ( l e t   i   =   s t a r t I n d e x ;   i   <   a r g s . c o u n t ;   i + + ) { 
 	 	 a r g v . p u s h ( O b j C . u n w r a p ( a r g s . o b j e c t A t I n d e x ( i ) ) ) ; 
 	 } 
 } 
 
 i f   ( a r g v . l e n g t h   = =   0 ) { 
 	 a r g v =   [ " 1 " ] ; 	 / /   d e f a u l t   i s   o n 
 } 
 
 / / d i s m i s s M o d a l D i a l o g ( ) ; 	 / /   d i s m i s s   m o d a l   d i a l o g s 
 / / c o n s o l e . l o g ( " a r g v "   ,   a r g v ) ; 
 r e s u l t   =   v i d e o O n l i n e ( a r g v [ 0 ] ) ; 
 / / l e t   s a m p l e R a t e   =   g e t T o t a l m i x S a m p l e R a t e ( ) ; 	 / / g e t S e s s i o n S a m p l e R a t e ( ) ; 
 / / c o n s o l e . l o g ( ' s a m p l e R a t e ' ,   s a m p l e R a t e ) ; 
 / /   w e   g e t   s a m p l e   r a t e   f r o m   U F X ,   d o n ' t   n e e d   i t   h e r e 
 r e s u l t ; 
 
 f u n c t i o n   v i d e o O n l i n e ( o n l i n e ) { 
 c o n s t   a p p   =   A p p l i c a t i o n ( ' S y s t e m   E v e n t s ' ) ; 
 c o n s t   p t   =   a p p . p r o c e s s e s [ ' P r o   T o o l s ' ] ; 
 
 / / c o n s o l e . l o g ( ' v i d e o O n l i n e ' ) ; 
     	 i f ( p t . e x i s t s ( ) ) { 
 	 
     	 	 p t . f r o n t m o s t   =   t r u e ; 
 	 	 / / c o n s o l e . l o g ( " o n l i n e   " ,   o n l i n e ) ; 
 
 	 	 v a r   b t n   =   p t . m e n u B a r s [ 0 ] . m e n u B a r I t e m s [ " O p t i o n s " ] . m e n u s [ " O p t i o n s " ] . m e n u I t e m s [ " V i d e o   T r a c k   O n l i n e " ] ; 
 	 	 
 	 	 / / i f ( b t n ) { 
 	 	 / / 	 c o n s o l e . l o g ( " t h e r e   i s   a   b u t t o n " ) 
 	 	 / / 	 l e t   n a m e s   =   b t n . a t t r i b u t e s . n a m e ( ) ; 
 	 	 / / 	 c o n s o l e . l o g ( " n a m e s   " , n a m e s ) ; 
 	 	 / / 	 l e t   m a r k   =   b t n . a t t r i b u t e s [ " A X M e n u I t e m M a r k C h a r " ] . v a l u e ( ) ; 
 	 	 / / 	 c o n s o l e . l o g ( " m a r k   "   , m a r k ) ; 
 	 	 / / 	 b t n . c l i c k ( ) ; 
 	 	 / / } ; 
 	 	 v a r   i s C h e c k e d   =   b t n . a t t r i b u t e s [ " A X M e n u I t e m M a r k C h a r " ] . v a l u e ( )   = =   "' "   ?   " 1 "   :   " 0 " ; 
 	 	 
 	 	 / / c o n s o l e . l o g ( " i s C h e c k e d " , i s C h e c k e d ,   o n l i n e ) ; 
 	 	 
 	 	 i f ( i s C h e c k e d   ! =   o n l i n e ) { 
 	 	 	 / / c o n s o l e . l o g ( " c l i c k i n g   b u t t o n " ) ; 
 	 	 	 b t n . c l i c k ( ) ; 
 	 	 } 
 	 } 
 	 
 	 r e t u r n   0 ; 
 } 
 f u n c t i o n   d i s m i s s M o d a l D i a l o g ( ) { 
 
 	 c o n s t   a p p   =   A p p l i c a t i o n ( ' S y s t e m   E v e n t s ' ) ; 
 	 c o n s t   p t   =   a p p . p r o c e s s e s [ ' P r o   T o o l s ' ] ; 
 
     	 i f ( p t . e x i s t s ( ) ) { 
 	 
     	 	 p t . f r o n t m o s t   =   t r u e ; 
 	 	 
 	 	 / / f o r ( l e t   i   =   0 ;   i   <   p t . w i n d o w s . l e n g t h ;   i + + ) { 
 	 	 / / 	 c o n s o l e . l o g ( p t . w i n d o w s [ i ] . n a m e ( ) ) ; 
 	 	 / / 	 c o n s o l e . l o g ( p t . w i n d o w s [ i ] . p r o p e r t i e s ( ) ) ; 
 	 	 / / 	 c o n s o l e . l o g ( p t . w i n d o w s [ i ] . a t t r i b u t e s . n a m e ( ) ) ; 
 	 	 / / 	 c o n s o l e . l o g ( p t . w i n d o w s [ i ] . b u t t o n s . n a m e ( ) ) ; 
 	 	 / / } 
 	 	 
 	 	 f o r ( l e t   i   =   0 ;   i   <   p t . w i n d o w s . l e n g t h ;   i + + ) { 
 	 	 	 	 	 	 	 	 	 	 	 	 
 	 	 	 i f ( p t . w i n d o w s [ i ] . b u t t o n s . n a m e ( ) . i n c l u d e s ( ' C a n c e l ' ) ) { 
 	 	 	 	 	 	 	 	 	 	 	 
 	 	 	 	 p t . w i n d o w s [ i ] . b u t t o n s [ ' C a n c e l ' ] . c l i c k ( ) ; 
 	 	 	 	 c o n s o l e . l o g ( ' d i d   c a n c e l ' , i ) ; 
 	 	 	 } e l s e   i f ( p t . w i n d o w s [ i ] . b u t t o n s . n a m e ( ) . i n c l u d e s ( ' O K ' ) ) { 
 	 	 	 	 	 	 	 	 	 	 	 
 	 	 	 	 p t . w i n d o w s [ i ] . b u t t o n s [ ' O K ' ] . c l i c k ( ) ; 
 	 	 	 	 c o n s o l e . l o g ( ' d i d   O K ' , i ) ; 
 	 	 	 } 	 
 	 	 } 
 	 	 r e t u r n   0 ; 
 	 } 
 	 r e t u r n   - 1 ; 
 } 
                              zjscr  ��ޭ