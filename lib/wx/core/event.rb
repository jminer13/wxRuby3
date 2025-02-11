
require_relative './evthandler'

module Wx

  # Base class for all events
  class Event

    # overload the #initialize method to add a check on a
    # correct match between EventType and event class
    wx_init = self.instance_method(:initialize)
    define_method :initialize do |evt_type = Wx::EVT_NULL, *rest|
      evt_klass = Wx::EvtHandler.event_class_for_type(evt_type)
      if evt_klass >= self.class
        wx_init.bind(self).call(evt_type, *rest)
      else
        ::Kernel.raise ArgumentError, "Invalid event type #{Wx::EvtHandler.event_name_for_type(evt_type)}:#{evt_type} for class #{self.class}"
      end
    end

    # Get the Wx id, not Ruby's deprecated Object#id
    alias :id :get_id
  end

  class Wx::CommandEvent

    # overload the #initialize method to add a check on a
    # correct match between EventType and event class
    wx_init = self.instance_method(:initialize)
    define_method :initialize do |evt_type = Wx::EVT_NULL, *rest|
      evt_klass = Wx::EvtHandler.event_class_for_type(evt_type)
      if evt_klass >= self.class
        wx_init.bind(self).call(evt_type, *rest)
      else
        ::Kernel.raise ArgumentError, "Invalid event type #{Wx::EvtHandler.event_name_for_type(evt_type)}:#{evt_type} for class #{self.class}"
      end
    end

  end

  # reduce mapping warnings for this unpublished event class
  NcPaintEvent = Wx::Event

  EvtHandler.register_event_type EvtHandler::EventType[
    'evt_nc_paint', 0,
    Wx::EVT_NC_PAINT,
    Wx::NcPaintEvent
  ]
end
