
class Wx::GraphicsContext

  # @overload self.draw_on(window)
  #   Creates a {Wx::GraphicsContext} from a {Wx::Window} and passes that object to the given block.
  #   Deletes the gc object after the block returns.
  #   @see Wx::GraphicsRenderer#create_context
  #   @param window [Wx::Window]
  #   @return [Wx::GraphicsContext]
  # @overload self.draw_on(windowDC)
  #   Creates a {Wx::GraphicsContext} from a {Wx::WindowDC} and passes that object to the given block.
  #   Deletes the gc object after the block returns.
  #   @see Wx::GraphicsRenderer#create_context
  #   @param windowDC [Wx::WindowDC]
  #   @return [Wx::GraphicsContext]
  # @overload self.draw_on(memoryDC)
  #   Creates a {Wx::GraphicsContext} from a {Wx::MemoryDC} and passes that object to the given block.
  #   Deletes the gc object after the block returns.
  #   @see Wx::GraphicsRenderer#create_context
  #   @param memoryDC [Wx::MemoryDC]
  #   @return [Wx::GraphicsContext]
  # @overload self.draw_on(printerDC)
  #   Creates a {Wx::GraphicsContext} from a {Wx::PrinterDC} and passes that object to the given block.
  #   Deletes the gc object after the block returns.
  #   Under GTK+, this will only work when using the GtkPrint printing backend which is available since GTK+ 2.10.
  #   @see Wx::GraphicsRenderer#create_context
  #   @see  Printing Under Unix (GTK+)
  #   @param printerDC [Wx::PrinterDC]
  #   @return [Wx::GraphicsContext]
  # @overload self.draw_on(image)
  #   Creates a {Wx::GraphicsContext} associated with a {Wx::Image} and passes that object to the given block.
  #   Deletes the gc object after the block returns.
  #   The image specifies the size of the context as well as whether alpha is supported (if {Wx::Image#has_alpha}) or not and the initial contents of the context. The image object must have a life time greater than that of the new context as the context copies its contents back to the image when it is destroyed.
  #   @param image [Wx::Image]
  #   @return [Wx::GraphicsContext]
  # @overload self.draw_on()
  #   Create a lightweight context that can be used only for measuring text and passes that object to the given block.
  #   Deletes the gc object after the block returns.
  #   @return [Wx::GraphicsContext]
  def self.draw_on(*args) end

end
