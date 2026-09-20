import { bookSpineColors } from './tokens';

export interface User {
  id: string;
  name: string;
  email: string;
}

export interface Member {
  userId: string;
  name: string;
  role: 'owner' | 'member';
}

export interface Library {
  id: string;
  name: string;
  code: string;
  ownerId: string;
  members: Member[];
}

export interface Location {
  id: string;
  libraryId: string;
  name: string;
  roomType: string;
  imageUrl?: string;
}

export interface Book {
  id: string;
  title: string;
  author: string;
  isbn: string;
  year: number;
  synopsis: string;
  locationId: string;
  libraryId: string;
  addedBy: string;
  addedAt: string;
  genre: string[];
  pages: number;
  color: string;
  coverUrl?: string;
}

export const currentUser: User = {
  id: 'u1',
  name: 'Mariana',
  email: 'mariana@email.com',
};

export const initialLibraries: Library[] = [
  {
    id: 'lib1',
    name: 'Casa dos Ipês',
    code: 'IPE-42',
    ownerId: 'u1',
    members: [
      { userId: 'u1', name: 'Mariana', role: 'owner' },
      { userId: 'u2', name: 'Paulo', role: 'member' },
      { userId: 'u3', name: 'Luís', role: 'member' },
    ],
  },
  {
    id: 'lib2',
    name: 'Apartamento 701',
    code: 'APT-07',
    ownerId: 'u1',
    members: [{ userId: 'u1', name: 'Mariana', role: 'owner' }],
  },
];

export const initialLocations: Location[] = [
  {
    id: 'loc1', libraryId: 'lib1', name: 'Sala de Estar', roomType: 'Sala',
    imageUrl: 'https://images.unsplash.com/photo-1603745676022-d1b77e3cbce8?w=400&h=200&fit=crop&q=80',
  },
  {
    id: 'loc2', libraryId: 'lib1', name: 'Quarto Principal', roomType: 'Quarto',
    imageUrl: 'https://images.unsplash.com/photo-1536965764833-5971e0abed7c?w=400&h=200&fit=crop&q=80',
  },
  {
    id: 'loc3', libraryId: 'lib1', name: 'Escritório', roomType: 'Escritório',
    imageUrl: 'https://images.unsplash.com/photo-1725783521817-3f37e54390a4?w=400&h=200&fit=crop&q=80',
  },
  { id: 'loc4', libraryId: 'lib1', name: 'Corredor', roomType: 'Corredor' },
  { id: 'loc5', libraryId: 'lib1', name: 'Cozinha', roomType: 'Cozinha' },
  { id: 'loc6', libraryId: 'lib1', name: 'Varanda', roomType: 'Varanda' },
  { id: 'loc7', libraryId: 'lib2', name: 'Sala', roomType: 'Sala' },
  { id: 'loc8', libraryId: 'lib2', name: 'Quarto', roomType: 'Quarto' },
];

export const initialBooks: Book[] = [
  {
    id: 'b1', title: 'A Roda do Tempo', author: 'Robert Jordan',
    isbn: '9788535902772', year: 1990, pages: 782,
    synopsis: 'Uma épica jornada de fantasia em que o Dragão Renascido deve salvar o mundo das forças das Trevas.',
    locationId: 'loc1', libraryId: 'lib1', addedBy: 'Mariana', addedAt: '2024-03-12',
    genre: ['Fantasia', 'Épico'], color: bookSpineColors[0],
    coverUrl: 'https://images.unsplash.com/photo-1633477189729-9290b3261d0a?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b2', title: 'O Nome do Vento', author: 'Patrick Rothfuss',
    isbn: '9788580860213', year: 2007, pages: 662,
    synopsis: 'A história de Kvothe, o lendário mago e músico, narrada em sua própria voz.',
    locationId: 'loc1', libraryId: 'lib1', addedBy: 'Mariana', addedAt: '2024-03-15',
    genre: ['Fantasia'], color: bookSpineColors[1],
    coverUrl: 'https://images.unsplash.com/photo-1739521949679-c9abf6e5c35e?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b3', title: 'Cem Anos de Solidão', author: 'Gabriel García Márquez',
    isbn: '9788501044070', year: 1967, pages: 432,
    synopsis: 'A saga da família Buendía ao longo de sete gerações na mítica Macondo.',
    locationId: 'loc2', libraryId: 'lib1', addedBy: 'Paulo', addedAt: '2024-02-20',
    genre: ['Realismo Mágico', 'Romance'], color: bookSpineColors[2],
    coverUrl: 'https://images.unsplash.com/photo-1697029749544-ffa7f15f9dd0?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b4', title: 'A Pedra da Luz', author: 'Christian Jacq',
    isbn: '9788532508654', year: 1995, pages: 348,
    synopsis: 'Um romance histórico ambientado no Egito Antigo, seguindo o artesão Nefer.',
    locationId: 'loc3', libraryId: 'lib1', addedBy: 'Mariana', addedAt: '2024-01-08',
    genre: ['Histórico', 'Ficção'], color: bookSpineColors[3],
    coverUrl: 'https://images.unsplash.com/photo-1784844149078-e580b938fd02?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b5', title: 'Duna', author: 'Frank Herbert',
    isbn: '9788501018941', year: 1965, pages: 688,
    synopsis: 'A história de Paul Atreides e sua ascensão como líder no planeta desértico Arrakis.',
    locationId: 'loc1', libraryId: 'lib1', addedBy: 'Luís', addedAt: '2024-03-01',
    genre: ['Ficção Científica', 'Épico'], color: bookSpineColors[4],
    coverUrl: 'https://images.unsplash.com/photo-1711185892711-cdf27b3b8b54?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b6', title: 'O Senhor dos Anéis', author: 'J.R.R. Tolkien',
    isbn: '9788535900075', year: 1954, pages: 1178,
    synopsis: 'A jornada de Frodo e seus companheiros para destruir o Um Anel na Montanha da Perdição.',
    locationId: 'loc1', libraryId: 'lib1', addedBy: 'Mariana', addedAt: '2024-02-28',
    genre: ['Fantasia', 'Épico'], color: bookSpineColors[5],
    coverUrl: 'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b7', title: 'Flores para Algernon', author: 'Daniel Keyes',
    isbn: '9788535915437', year: 1966, pages: 311,
    synopsis: 'Charlie Gordon, com QI baixo, participa de uma experiência que triplica sua inteligência.',
    locationId: 'loc2', libraryId: 'lib1', addedBy: 'Paulo', addedAt: '2024-01-20',
    genre: ['Ficção Científica'], color: bookSpineColors[6],
    coverUrl: 'https://images.unsplash.com/photo-1630343710506-89f8b9f21d31?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b8', title: 'A Casa dos Espíritos', author: 'Isabel Allende',
    isbn: '9788532511081', year: 1982, pages: 433,
    synopsis: 'A saga da família Trueba através de gerações no Chile.',
    locationId: 'loc2', libraryId: 'lib1', addedBy: 'Mariana', addedAt: '2024-03-10',
    genre: ['Realismo Mágico', 'Romance'], color: bookSpineColors[0],
    coverUrl: 'https://images.unsplash.com/photo-1652940113952-71e4eeca0539?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b9', title: 'O Mestre e Margarida', author: 'Mikhail Bulgákov',
    isbn: '9788535903861', year: 1967, pages: 385,
    synopsis: 'Uma sátira fantástica sobre a visita do diabo à Moscou soviética dos anos 1930.',
    locationId: 'loc3', libraryId: 'lib1', addedBy: 'Luís', addedAt: '2024-02-05',
    genre: ['Fantasia', 'Sátira'], color: bookSpineColors[1],
    coverUrl: 'https://images.unsplash.com/photo-1601804590276-e19ce20343da?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b10', title: 'Fundação', author: 'Isaac Asimov',
    isbn: '9788535902246', year: 1951, pages: 255,
    synopsis: 'Hari Seldon cria a Fundação para preservar o conhecimento humano durante a queda do Império Galáctico.',
    locationId: 'loc3', libraryId: 'lib1', addedBy: 'Paulo', addedAt: '2024-01-15',
    genre: ['Ficção Científica'], color: bookSpineColors[2],
    coverUrl: 'https://images.unsplash.com/photo-1711185892188-13f35959d3ca?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b11', title: 'Memórias Póstumas de Brás Cubas', author: 'Machado de Assis',
    isbn: '9788535900013', year: 1881, pages: 208,
    synopsis: 'Um defunto-autor narra sua própria vida com ironia e humor sardônico.',
    locationId: 'loc4', libraryId: 'lib1', addedBy: 'Mariana', addedAt: '2024-03-18',
    genre: ['Romance', 'Clássico'], color: bookSpineColors[3],
    coverUrl: 'https://images.unsplash.com/photo-1645199055608-fce5ca0d098e?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b12', title: 'A Insustentável Leveza do Ser', author: 'Milan Kundera',
    isbn: '9788532500412', year: 1984, pages: 314,
    synopsis: 'Quatro personagens na Praga comunista exploram amor, política e as consequências das escolhas.',
    locationId: 'loc1', libraryId: 'lib1', addedBy: 'Luís', addedAt: '2024-02-14',
    genre: ['Romance', 'Filosofia'], color: bookSpineColors[4],
    coverUrl: 'https://images.unsplash.com/photo-1699443817739-cf2f7cbcd18d?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b13', title: 'Brida', author: 'Paulo Coelho',
    isbn: '9788520006286', year: 1990, pages: 216,
    synopsis: 'Brida, uma jovem irlandesa, busca seu dom espiritual guiada por um mago e uma feiticeira.',
    locationId: 'loc5', libraryId: 'lib1', addedBy: 'Mariana', addedAt: '2024-01-30',
    genre: ['Ficção', 'Espiritual'], color: bookSpineColors[5],
    coverUrl: 'https://images.unsplash.com/photo-1603058817990-2b9a9abbce86?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b14', title: 'O Hobbit', author: 'J.R.R. Tolkien',
    isbn: '9788535900068', year: 1937, pages: 336,
    synopsis: 'Bilbo Bolseiro embarca numa aventura inesperada com treze anões e um mago.',
    locationId: 'loc2', libraryId: 'lib1', addedBy: 'Paulo', addedAt: '2024-03-05',
    genre: ['Fantasia'], color: bookSpineColors[6],
    coverUrl: 'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?w=400&h=300&fit=crop&q=80',
  },
  {
    id: 'b15', title: 'Neuromancer', author: 'William Gibson',
    isbn: '9788535910210', year: 1984, pages: 271,
    synopsis: 'Case, um hacker arruinado, é contratado para um último trabalho no ciberespaço.',
    locationId: 'loc3', libraryId: 'lib1', addedBy: 'Luís', addedAt: '2024-02-22',
    genre: ['Ficção Científica', 'Cyberpunk'], color: bookSpineColors[7],
    coverUrl: 'https://images.unsplash.com/photo-1784844149078-e580b938fd02?w=400&h=600&fit=crop&q=80',
  },
  {
    id: 'b16', title: 'Grande Sertão: Veredas', author: 'João Guimarães Rosa',
    isbn: '9788520000017', year: 1956, pages: 624,
    synopsis: 'O jagunço Riobaldo narra sua vida no sertão mineiro em um monólogo filosófico e poético.',
    locationId: 'loc6', libraryId: 'lib1', addedBy: 'Paulo', addedAt: '2024-02-18',
    genre: ['Romance', 'Brasileiro'], color: bookSpineColors[8],
    coverUrl: 'https://images.unsplash.com/photo-1630343710506-89f8b9f21d31?w=400&h=600&fit=crop&q=80',
  },
];
