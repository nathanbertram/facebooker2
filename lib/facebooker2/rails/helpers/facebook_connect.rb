module Facebooker2
  module Rails
    module Helpers
      module FacebookConnect 
        # Render an <fb:login-button> element
        #
        # ==== Examples
        #
        #   <%= fb_login_button%>
        #   => <fb:login-button></fb:login-button>
        #
        # Specifying a javascript callback
        #
        #   <%= fb_login_button 'update_something();'%>
        #   => <fb:login-button onlogin='update_something();'></fb:login-button>
        #
        # Adding options <em>See:</em> http://wiki.developers.facebook.com/index.php/Fb:login-button
        #
        #   <%= fb_login_button 'update_something();', :size => :small, :background => :dark%>
        #   => <fb:login-button background='dark' onlogin='update_something();' size='small'></fb:login-button>
        #
        # :text option allows you to set the text value of the
        # button.  *A note!* This will only do what you expect it to do
        # if you set :v => 2 as well.
        #
        #   <%= fb_login_button 'update_somethign();',
        #        :text => 'Loginto Facebook', :v => 2 %>
        #   => <fb:login-button v='2' onlogin='update_something();'>Login to Facebook</fb:login-button>

        def fb_login_button(*args)
          callback = args.first
          options = args[1] || {}
          options.merge!(:onlogin=>callback) if callback

          text = options.delete(:text)

          content_tag("fb:login-button",text, options)
        end

        #
        # Render an <fb:login-button> element, similar to
        # fb_login_button. Adds a js redirect to the onlogin event via rjs.
        #
        # ==== Examples
        #
        #   fb_login_and_redirect '/other_page'
        #   => <fb:login-button onlogin="window.location.href = &quot;/other_page&quot;;"></fb:login-button>
        #
        # Like #fb_login_button, this also supports the :text option
        #
        #   fb_login_and_redirect '/other_page', :text => "Login with Facebook", :v => '2'
        #   => <fb:login-button onlogin="window.location.href = &quot;/other_page&quot;;" v="2">Login with Facebook</fb:login-button>
        #
        def fb_login_and_redirect(url, options = {})
          js = update_page do |page|
            page.redirect_to url
          end

          text = options.delete(:text)
          
          content_tag("fb:login-button",text,options.merge(:onlogin=>js))
        end
        
        #
        # Logs the user out of facebook and redirects to the given URL
        #  args are passed to the call to link_to_function
        def fb_logout_link(text,url,*args)
          function= "FB.logout(function() {window.location.href = '#{url}';})"
          link_to_function text, function, *args
        end
        
        def fb_server_fbml(style=nil,&proc)
          style_string=" style=\"#{style}\"" if style
          content = capture(&proc)
          concat("<fb:serverFbml#{style_string}><script type='text/fbml'>#{content}</script></fb:serverFbml>")
        end
      end
    end
  end
end