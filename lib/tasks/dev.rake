namespace :dev do
  desc "Reset the database"
  task reset: :environment do
    system("rails db:drop")
    system("rails db:create")
    system("rails db:migrate")
    system("rails db:seed")
    system("rails dev:add_customers")
    system("rails dev:add_equipaments")
    system("rails dev:add_orders")
  end

  desc "Add customers to the database"
  task add_customers: :environment do
    show_spinner("Adding customers to the database") { add_customers }
  end

  desc "Add equipaments to the database"
  task add_equipaments: :environment do
    show_spinner("Adding equipaments to the database") { add_equipaments }
  end

  desc "Add orders to the database"
  task add_orders: :environment do
    show_spinner("Adding orders to the database") { add_orders }
  end

  def add_customers
    Customer.create!(
      name: "Jose Maria da Silva Bueno",
      dob: "1968-10-04",
      email: "joca@email.com",
      mobile_phone: "(21)97676-8743",
      address: "Rua Bonifacio e Sikva, 234, Bento Ribeiro, Rio de Janeiro, RJ, Cep:22755-200",
      identification: "497.465.770-42",
      password: ENV["DEFAULT_PASSWORD"],
      password_confirmation: ENV["DEFAULT_PASSWORD"],
    )
    Customer.create!(
      name: "Margoth Sarinas Belustre",
      dob: "1980-06-24",
      email: "margo@email.com",
      mobile_phone: "(33)87654-0143",
      address: "Rua Mariz e Barros, 100/502, Tijuca, Rio de Janeiro, RJ, Cep:22755-190",
      identification: "323.433.240-18",
      password: ENV["DEFAULT_PASSWORD"],
      password_confirmation: ENV["DEFAULT_PASSWORD"],
    )
  end

  def add_equipaments
    [ "Empilhadeira Elétrica XYZ-500", "Guindaste Hidráulico 20t", "Plataforma Elevatória Tesoura 10m",
      "Compactador de Solo a Gasolina", "Furadeira de Impacto 220V", "Gerador Diesel 10kVA",
      "Betoneira 400L", "Andaime Modular 3m", "Escavadeira Hidráulica 20t", "Rolo Compactador Vibratório 3t",
      "Lavadora de Alta Pressão 1500 psi", "Parafusadeira Elétrica", "Cortadora de Piso a Gasolina",
      "Soprador Térmico Industrial", "Lixadeira Orbital 220V", "Serra Circular 7 1/4''",
      "Compressor de Ar 200L", "Ponte Rolante 5t", "Trator Agrícola 4x4", "Pulverizador Costal Motorizado",
      "Carregador de Baterias 12V", "Retificadora Angular", "Martelo Demolidor 10kg", "Roçadeira a Gasolina",
      "Furadeira de Bancada", "Vibrador de Concreto Elétrico", "Motocultivador a Gasolina",
      "Torre de Iluminação Móvel", "Máquina de Solda Inversora", "Cortadora de Vergalhão",
      "Pá Carregadeira 3t", "Decapadora de Pintura", "Lavadora a Vapor Industrial",
      "Máquina de Limpeza de Dutos", "Transformador de Solda", "Soprador de Folhas a Gasolina",
      "Desintegrador de Resíduos", "Minicarregadeira Bobcat", "Perfuratriz de Solo a Gasolina",
      "Serra Tico-Tico Industrial", "Calibrador de Pneus Digital", "Torre de Resfriamento",
      "Desumidificador de Ar", "Plataforma Articulada 15m", "Empilhadeira a Combustão",
      "Picador de Galhos a Gasolina", "Compressores de Ar Portátil", "Detector de Metais Industrial",
      "Gerador a Gasolina 5kVA", "Retroescavadeira 4x4", "Draga de Sucção", "Escavadeira de Esteiras",
      "Motoniveladora", "Trilha de Compactação", "Caminhão Betoneira", "Máquina de Solda a Arco",
      "Gerador de Energia Solar", "Elevador de Carga", "Máquina de Corte a Jato de Água",
      "Máquina de Perfuração Diamantina", "Máquina de Lavar Alta Pressão Elétrica",
      "Máquina de Solda MIG/MAG", "Máquina de Solda TIG", "Máquina de Solda a Ponto",
      "Máquina de Solda a Feixe de Eletrons", "Máquina de Solda a Laser", "Máquina de Solda a Resistência",
      "Máquina de Solda a Arco Submerso", "Máquina de Solda a Arco com Fluxo",
      "Máquina de Solda a Arco com Gás"].each do |name|
      equipament = Equipament.create!(
        name: name,
        description: Faker::Lorem.paragraph(sentence_count: rand(18..36)),
        status: "available",
        serial_number: "#{rand(1000..3000)}-#{rand(1000..5000)}-#{rand(4000..9999)}",
        rent_value: rand(450..1600)
      )
      image_id = rand(1..31)
      equipament.image.attach(
        # io: File.open(Rails.root.join("lib/tasks/images/full-hd/0#{image_id}.jpg")),
        io: Rails.root.join("lib/tasks/images/equipo#{image_id}.png").open,
        filename: "equipo_#{image_id}.png",
      )
    end
  end

  def add_orders
    from_date = DateTime.now - 180.days
    to_date = DateTime.now - 21.days
    80.times do
      payment = [["cartao"," ", " "], ["pix", "123456789012345", " "], ["boleto", " ", "12234567890123456789012345"]]
      index = rand(0..2)
      pay = payment[index]
      date_start = Faker::Date.between(from: from_date, to: to_date)
      number_end = rand(1..20)
      date_end = date_start + number_end
      equipament = Equipament.all.sample
      rentvalue = equipament.rent_value
      date_start_as_datetime = date_start = date_start.to_datetime.change({
        hour: rand(0..23),
        min: rand(0..59),
        sec: rand(0..59)
      })
      code = date_start_as_datetime.strftime('%Y%m%d%H%M%S%L')
      number = rand(0..9)
      order_code = "#{code}#{number}"

      # Criando a ordem sem validação
      order = Order.new(
        customer_id: Customer.all.sample.id,
        equipament_id: equipament.id,
        order_code: order_code,
        period_start: date_start,
        period_end: date_end,
        status: "finished",
        rent_value: rentvalue,
        tot_rent_value: rentvalue.to_i * (date_end - date_start).to_i + 1,
        payment_method: pay[0],
        installments: 1,
        pix_code: pay[1],
        ticket_barcode: pay[2],
        created_at: date_start
      )

      # Salvando sem validações
      order.save!(validate: false, before_validation: false)

      Schedule.create!(
        order_id: order.id,
        equipament_id: equipament.id,
        status: "done",
        period_start: date_start,
        period_end: date_end
      )
    end
  end


  def show_spinner(msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

end
