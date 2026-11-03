function invFUN(action)

%**************************************************************%
%This functions is intended for use with the invGUI.m file.  It%
%contains the code necessary to run the GUI's simulations and  %
%controls.                                                     %
%                                                              %
%Copyright (C) 1997 by the Regents of the University of        %
%Michigan.                                                     %
%**************************************************************%

%The callback for the RUN button%
if action == 1
     A = [0   1.0000        0        0;
          0  -0.1818   2.6727        0;
          0        0        0   1.0000;
          0  -0.4545  31.1818        0];
	 B = [0; 1.8182; 0; 4.5455];
     C = [1 0 0 0];
     D = [0];

%Get the weighing factors from the editable text fields%
      xhandle=findobj('Tag','xtext');
	  x=eval(get(xhandle,'String'));	
      yhandle=findobj('Tag','ytext');
	  y=eval(get(yhandle,'String'));
	  
      Q=[x 0 0 0;
         0 0 0 0;
         0 0 y 0;
         0 0 0 0];
      R = 1;
      
%Find the K matrix with the lqr command%      
      K = lqr(A,B,Q,R);
      Ac = [(A-B*K)];
      Bc = [B];
      Cc = [C];
      Dc = [D];

%Check if the refernece input is selected%      
      Nbarhandle = findobj('Tag','reference');
      Nbarval = get(Nbarhandle,'Value');
      if Nbarval == 0
        Nbar = 1;
        Nbarfhandle = findobj('Tag','Nbarframe');
        set(Nbarfhandle,'Value',Nbar);
        stepaxis=stepval/1000; 
      elseif Nbarval == 1
        s = size(A,1);
        Z = [zeros([1,s]) 1];
        N = inv([A,B;C,D])*Z';
        Nx = N(1:s);
        Nu = N(1+s);
        Nbar=Nu + K*Nx;
        Nbarfhandle = findobj('Tag','Nbarframe');
        set(Nbarfhandle,'Value',Nbar);  
      end         

%Get the value of the step input from the step slider%
      stephandle = findobj('Tag','stepslider');
      stepval=get(stephandle,'Value');

%Check whether linear or non-linear system is to be run%
      syshandle = findobj('Tag','syscheckbox');
      sysval = get(syshandle,'Value');
    
      if sysval == 0                
        T=0:0.1:6;      
        U=stepval*ones(size(T));
        [Y,X]=lsim(Ac,Nbar*Bc,Cc,Dc,U,T);
        cartpos=X(:,1);
        pendangl=X(:,3);      
      else  
        x0=[0 0 0 0];

%Check version of Matlab%  
        v=version;
    
	if eval(v(1))>=5
           tspan=[0 6];
           %options=odeset('Refine',1,'RelTol',1e-2,'AbsTol',1e-5);
	   'Please wait while simulation is running'
           [T,X]=ode45('invODE',tspan,x0);
        else
           'Please wait while simulation is running'
           [T,X]=ode45('invODE',0,6,x0); 
        end
    
        cartpos=X(:,1);
        pendangl=X(:,3);
      end

%Pendulum and cart data%    
      cart_length=0.3;
      cl2=cart_length/2;
      
      ltime=length(cartpos);
      
      cartl=cartpos-cl2;
      cartr=cartpos+cl2;
      
      pendang=-pendangl;
      pendl=0.6;
    
      pendx=pendl*sin(pendang)+cartpos;
      pendy=pendl*cos(pendang)+0.03;

%Check if the step response and animation are to be plotted separately%      
      plothandle = findobj('Tag','plotbox');
      plotval=get(plothandle,'Value');   
      if plotval == 1
         subplot(2,2,2)
         plot(T,cartpos,'r')
         plot(T,pendangl,'b')
      elseif plotval == 0
         subplot(2,2,2) 
         plot(T(1),cartpos(1), 'r', 'EraseMode', 'none')
         plot(T(1),pendangl(1), 'b', 'EraseMode', 'none')
      end

%Set the axis for the step response plot%      
      if stepval > 0
        axis([0 6 -stepval/2 stepval*2])
      elseif stepval < 0
        axis([0 6 stepval*2 -stepval/2])
      else
        axis([0 6 -0.5 0.5])
      end
      
      title(sprintf('Step Response to %0.4f cm input',stepval))
      xlabel('Time (sec)')
      
      
      hold on
      
%Plot the first frame of the animation%          
      subplot(2,2,4)
      cla
      L = plot([cartpos(1) pendx(1)], [0.03 pendy(1)], 'b', 'EraseMode', ...
      'xor','LineWidth',[7]);
      hold on
      J = plot([cartl(1) cartr(1)], [0 0], 'r', 'EraseMode', ...
      'xor','LineWidth',[20]);  
      
      axis([-.7 0.7 -0.1 0.7])
      title('Inverted Pendulum Animation')
      xlabel('X Position (m)')
      ylabel('Y Position (m)')
      
%Check if the animation is to be advanced manually%      
      manhandle = findobj('Tag','manualbox');
      manual=get(manhandle,'Value');
      
%Run the animation%      
      for i = 2:ltime-1,
         if manual == 1
              pause
         end
          
         set(J,'XData', [cartl(i) cartr(i)]);
         set(L,'XData', [cartpos(i) pendx(i)]);
         set(L,'YData', [0.03 pendy(i)]); 
         drawnow;
         
         if plotval == 0	
             subplot(2,2,2)
             plot([T(i),T(i+1)],[cartpos(i),cartpos(i+1)], 'r', 'EraseMode', 'none')
             plot([T(i),T(i+1)],[pendangl(i),pendangl(i+1)], 'b', 'EraseMode', 'none')
         end
     end

%Add legend to step plot%
    subplot(2,2,2)
    hold on
    legend('Pendulum Angle (rad.)','Cart Position (cm.)')

%Store the data in the GUI%      
    Khandle = findobj('Tag','Kframe');
    set(Khandle,'Value',K);      
    carthand = findobj('Tag','cartframe');
    set(carthand,'Value',cartpos);
    pendhand = findobj('Tag','pendframe');
    set(pendhand,'Value',pendangl);
    timehandle = findobj('Tag','timeframe');
    set(timehandle,'Value',T);          
     
%Callback for the RESET button%
elseif action == 2	
    subplot(2,2,2)
    cla
    axis([0 6 -0.5 0.5])
    title('Step Response')
    xlabel('Time (sec)')
    
    subplot(2,2,4)
    cartpos=0;
    cart_length=0.3;
    cl2=cart_length/2;
      
    cartl=cartpos-cl2;
    cartr=cartpos+cl2;
      
    pendang=0;
    pendl=0.6;
    
    pendx=pendl*sin(pendang)+cartpos;
    pendy=pendl*cos(pendang)+0.03;
    cla
    K = plot([cartpos(1) pendx(1)], [0.03 pendy(1)], 'b', 'EraseMode', ...
    'xor','LineWidth',[7]);
    hold on
    J = plot([cartl(1) cartr(1)], [0 0], 'r', 'EraseMode', ...
    'xor','LineWidth',[20]);  
     
%Callback for the current value of the step-slider%          
elseif action == 3
    stephandle = findobj('Tag','stepslider');
    stepval=get(stephandle,'Value');
    curhandle = findobj('Tag','curtext');
    set(curhandle,'String',sprintf('%6.4f',stepval)); 	  	  


%Callback for the REPEAT button%
elseif action == 4
    carthand = findobj('Tag','cartframe');
    cartpos=get(carthand,'Value');
    pendhand = findobj('Tag','pendframe');
    pendangl=get(pendhand,'Value');
    timehandle = findobj('Tag','timeframe');
    T=get(timehandle,'Value'); 
     
    cart_length=0.3;
    cl2=cart_length/2;
      
    ltime=length(cartpos);
      
    cartl=cartpos-cl2;
    cartr=cartpos+cl2;
      
    pendang=-pendangl;
    pendl=0.6;
    
    pendx=pendl*sin(pendang)+cartpos;
    pendy=pendl*cos(pendang)+0.03;
      
    plothandle = findobj('Tag','plotbox');
    plotval=get(plothandle,'Value');   
    if plotval == 1
       subplot(2,2,2)
       plot(T,cartpos,'r')
       plot(T,pendangl,'b')
       legend('Cart','Pendulum')
    elseif plotval == 0
       subplot(2,2,2) 
       plot(T(1),cartpos(1), 'r', 'EraseMode', 'none')
       plot(T(1),pendangl(1), 'b', 'EraseMode', 'none')
    end
      
    stephandle = findobj('Tag','stepslider');
    stepval=get(stephandle,'Value');
    Nbarhandle = findobj('Tag','reference');
    Nbarval = get(Nbarhandle,'Value');
    if Nbarval == 1
      stepaxis=stepval;
    else
      stepaxis=stepval/1000;   
    end
      
    if stepval > 0
      axis([0 6 -stepval/2 stepval*2])
    elseif stepval < 0
      axis([0 6 stepval*2 -stepval/2])
    else
      axis([0 6 -0.5 0.5])
    end
      
    title(sprintf('Step Response to %0.4f cm input',stepval))
    xlabel('Time (sec)')
      
      
    hold on
          
    subplot(2,2,4)
    cla
    L = plot([cartpos(1) pendx(1)], [0.03 pendy(1)], 'b', 'EraseMode', ...
    'xor','LineWidth',[7]);
    hold on
    J = plot([cartl(1) cartr(1)], [0 0], 'r', 'EraseMode', ...
    'xor','LineWidth',[20]);  
    
    axis([-.7 0.7 -0.1 0.7])
    title('Inverted Pendulum Animation')
    xlabel('X Position (m)')
    ylabel('Y Position (m)')
     
    manhandle = findobj('Tag','manualbox');
    manual=get(manhandle,'Value');
     
      
    for i = 2:ltime-1,
       if manual == 1
            pause
       end
         
       set(J,'XData', [cartl(i) cartr(i)]);
       set(L,'XData', [cartpos(i) pendx(i)]);
       set(L,'YData', [0.03 pendy(i)]); 
       drawnow;
         
       if plotval == 0	
           subplot(2,2,2)
           plot([T(i),T(i+1)],[cartpos(i),cartpos(i+1)], 'r', 'EraseMode','none')
           plot([T(i),T(i+1)],[pendangl(i),pendangl(i+1)], 'b', 'EraseMode','none')
       end
   end
end
