require 'csv'

GuestbookEntry = Struct.new(:name, :message, :date, :public)

class Guestbook
    attr_reader :data

    def initialize
        @file_path = APP_ROOT + '/data/guestbook.csv'
        self.reload
    end

    def reload
        @data = []
        return unless File.file?(@file_path)
        CSV.foreach(@file_path) do |row|
            @data << GuestbookEntry.new(
                row[0], row[1], row[2], (row[3] == 'true')
            )
        end
    end

    def add(name, message)
        date = Date.today.strftime('%Y-%m-%d')
        @data << GuestbookEntry.new(name, message, date, true)
        self.save
    end

    def save
        CSV.open(@file_path, 'w') do |csv|
            @data.each do |entry|
                csv << [
                    entry.name, entry.message, entry.date, entry.public
                ]
            end
        end
    end

    def public_entries
        self.reload
        return @data
            .select { |entry| entry.public }
            .sort { |a, b| b.date <=> a.date }
    end
end

$guestbook = Guestbook.new