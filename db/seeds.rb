abort("Seeding is intended for development only.") unless Rails.env.development?

srand(2026)

START_DATE = Date.new(2026, 3, 1)
END_DATE = Date.new(2026, 6, 24)
PLACEHOLDER_IMAGE_CANDIDATES = [
  Rails.root.join("db/seeds/placeholder.jpg"),
  Rails.root.join("db/seeds/placeholder.jpeg"),
  Rails.root.join("db/seeds/placeholder.png"),
  Rails.root.join("tmp/test_placeholder.jpg"),
  Rails.root.join("tmp/test_placeholder.png"),
  Rails.root.join("test/fixtures/files/placeholder.jpg"),
  Rails.root.join("test/fixtures/files/placeholder.png"),
  Rails.root.join("public/icon.png")
].freeze

JAN_NOTES = [
  "Dobry dzień, duża dawka energii.",
  "Lekkie zakwasy po treningu nóg.",
  "Waga stabilna, trzymam miskę.",
  "Gorzej przespana noc, ale samopoczucie OK.",
  "Po weekendzie czuję lekką retencję wody.",
  "Spokojny spacer i dobra regeneracja.",
  "Brzuch wyraźnie spokojniejszy niż w zeszłym tygodniu."
].freeze

ANNA_NOTES = [
  "Regularny cotygodniowy pomiar kontrolny.",
  "Trzymam rytm i plan posiłków.",
  "Dzisiaj czuję się lżej i bardziej mobilnie.",
  "Weekend był intensywny, ale wracam do rutyny.",
  "Niewielki spadek, ale obwody idą w dobrą stronę."
].freeze

STOOL_COLORS = ["jasnobrązowy", "brązowy", "ciemnobrązowy"].freeze

def placeholder_photo_path
  PLACEHOLDER_IMAGE_CANDIDATES.find(&:exist?)
end

def attach_dummy_photo(entry, slot_name, source_path)
  return unless source_path

  attachment = entry.public_send(slot_name)
  return if attachment.attached?

  attachment.attach(
    io: File.open(source_path, "rb"),
    filename: File.basename(source_path),
    content_type: Marcel::MimeType.for(Pathname.new(source_path), name: File.basename(source_path))
  )
end

def build_entry_timestamp(date, hour_range)
  date.to_time.in_time_zone + rand(hour_range).hours + rand(0..45).minutes
end

def trend_value(current_value, change, multiplier:, min:)
  [(current_value + (change * multiplier)).round(2), min].max
end

def maybe_attach_photos(entry, source_path, chance:)
  return unless rand < chance

  attach_dummy_photo(entry, :photo_front, source_path) if rand < 0.95
  attach_dummy_photo(entry, :photo_back, source_path) if rand < 0.8
  attach_dummy_photo(entry, :photo_side, source_path) if rand < 0.9
end

puts "Clearing existing database entries..."
MeasurementEntry.destroy_all
User.destroy_all

puts "Creating test users..."
jan = User.create!(
  email: "jan@example.com",
  username: "jan_nowak",
  password: "password123",
  password_confirmation: "password123"
)

anna = User.create!(
  email: "anna@example.com",
  username: "anna_kowalska",
  password: "password123",
  password_confirmation: "password123"
)

photo_source = placeholder_photo_path

if photo_source
  puts "Photo placeholder found at #{photo_source}."
else
  puts "No placeholder photo found. Photo attachments will be skipped gracefully."
end

puts "Generating historical entries for Jan (consistent tracking)..."
current_weight = 100.4
current_body_fat = 25.2
current_waist = 103.5
current_abdomen = 106.0
current_chest = 110.2
current_biceps = 38.4
current_thigh = 63.2
current_calf = 42.0
current_buttocks = 106.4
current_forearm = 30.1

(START_DATE..END_DATE).step(3).each_with_index do |date, index|
  weight_change =
    if index.zero?
      rand(-0.2..0.0)
    else
      rand(-0.45..0.18)
    end

  current_weight = trend_value(current_weight, weight_change, multiplier: 1.0, min: 91.0)
  current_body_fat = trend_value(current_body_fat, weight_change, multiplier: 0.28, min: 18.8)
  current_waist = trend_value(current_waist, weight_change, multiplier: 0.42, min: 94.0)
  current_abdomen = trend_value(current_abdomen, weight_change, multiplier: 0.5, min: 96.0)
  current_chest = trend_value(current_chest, weight_change, multiplier: 0.18, min: 106.0)
  current_biceps = trend_value(current_biceps, weight_change, multiplier: 0.06, min: 36.5)
  current_thigh = trend_value(current_thigh, weight_change, multiplier: 0.14, min: 59.5)
  current_calf = trend_value(current_calf, weight_change, multiplier: 0.06, min: 39.5)
  current_buttocks = trend_value(current_buttocks, weight_change, multiplier: 0.22, min: 100.5)
  current_forearm = trend_value(current_forearm, weight_change, multiplier: 0.03, min: 28.5)

  timestamp = build_entry_timestamp(date, 6..9)

  entry = jan.measurement_entries.create!(
    weight: current_weight,
    body_fat: current_body_fat.round(2),
    waist: current_waist.round(2),
    abdomen: current_abdomen.round(2),
    chest: current_chest.round(2),
    biceps: current_biceps.round(2),
    thigh: current_thigh.round(2),
    calf: current_calf.round(2),
    buttocks: current_buttocks.round(2),
    forearm: current_forearm.round(2),
    mood: rand(3..5),
    sleep_quality: rand(2..5),
    bristol_stool_type: rand(3..5),
    stool_color: STOOL_COLORS.sample,
    note: JAN_NOTES.sample,
    created_at: timestamp,
    updated_at: timestamp
  )

  maybe_attach_photos(entry, photo_source, chance: 0.33)
end

puts "Generating historical entries for Anna (weekly tracking)..."
current_weight = 75.6
current_body_fat = 30.8
current_waist = 83.5
current_abdomen = 88.4
current_chest = 94.1
current_biceps = 29.2
current_thigh = 57.5
current_calf = 36.8
current_buttocks = 100.8
current_forearm = 22.8

(START_DATE..END_DATE).step(7).each_with_index do |date, index|
  weight_change =
    if index.zero?
      rand(-0.15..0.0)
    else
      rand(-0.55..0.14)
    end

  current_weight = trend_value(current_weight, weight_change, multiplier: 1.0, min: 68.0)
  current_body_fat = trend_value(current_body_fat, weight_change, multiplier: 0.24, min: 25.5)
  current_waist = trend_value(current_waist, weight_change, multiplier: 0.4, min: 76.5)
  current_abdomen = trend_value(current_abdomen, weight_change, multiplier: 0.45, min: 81.5)
  current_chest = trend_value(current_chest, weight_change, multiplier: 0.16, min: 90.5)
  current_biceps = trend_value(current_biceps, weight_change, multiplier: 0.05, min: 27.0)
  current_thigh = trend_value(current_thigh, weight_change, multiplier: 0.12, min: 54.0)
  current_calf = trend_value(current_calf, weight_change, multiplier: 0.04, min: 35.2)
  current_buttocks = trend_value(current_buttocks, weight_change, multiplier: 0.18, min: 95.2)
  current_forearm = trend_value(current_forearm, weight_change, multiplier: 0.02, min: 21.8)

  timestamp = build_entry_timestamp(date, 7..10)

  entry = anna.measurement_entries.create!(
    weight: current_weight,
    body_fat: current_body_fat.round(2),
    waist: current_waist.round(2),
    abdomen: current_abdomen.round(2),
    chest: current_chest.round(2),
    biceps: current_biceps.round(2),
    thigh: current_thigh.round(2),
    calf: current_calf.round(2),
    buttocks: current_buttocks.round(2),
    forearm: current_forearm.round(2),
    mood: rand(2..5),
    sleep_quality: rand(3..5),
    bristol_stool_type: rand(3..4),
    stool_color: "brązowy",
    note: ANNA_NOTES.sample,
    created_at: timestamp,
    updated_at: timestamp
  )

  maybe_attach_photos(entry, photo_source, chance: 0.2)
end

puts "Database successfully seeded with realistic history!"
puts "Test users:"
puts "  jan@example.com / jan_nowak / password123"
puts "  anna@example.com / anna_kowalska / password123"
