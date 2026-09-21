class IcalService
  def self.tasks_calendar(tasks:, calendar_name:)
    events = tasks.select(&:due_date).map { |t| event_for(t) }.join
    <<~ICS
      BEGIN:VCALENDAR
      VERSION:2.0
      PRODID:-//Czar//Tasks//PT-BR
      X-WR-CALNAME:#{escape(calendar_name)}
      #{events}END:VCALENDAR
    ICS
  end

  def self.event_for(task)
    <<~EVT
      BEGIN:VEVENT
      UID:task-#{task.id}@czar
      DTSTAMP:#{Time.current.utc.strftime("%Y%m%dT%H%M%SZ")}
      DTSTART;VALUE=DATE:#{task.due_date.strftime("%Y%m%d")}
      SUMMARY:#{escape(task.title)}
      DESCRIPTION:#{escape(task.description.to_s[0, 500])}
      END:VEVENT
    EVT
  end

  def self.escape(text)
    text.to_s.gsub("\\", "\\\\").gsub("\n", "\\n").gsub(",", "\\,").gsub(";", "\\;")
  end
end
