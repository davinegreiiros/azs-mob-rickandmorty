# Rick & Morty Episodes — AZShip Technical Challenge

Flutter app para gerenciar episódios de Rick and Morty, consumindo a [Rick and Morty GraphQL API](https://rickandmortyapi.com/graphql).

---

## Features

| Funcionalidade | Status |
| --- | --- |
| Listagem de todos os episódios (número, nome, data, qtd. de personagens) | ✅ |
| Detalhe do episódio com lista de personagens (foto, nome, espécie, status) | ✅ |
| Favoritar / desfavoritar episódio | ✅ |
| Marcar episódio como visto | ✅ |
| Listagem de episódios favoritos | ✅ |
| Busca por nome | ✅ |
| Persistência de favoritos e vistos entre sessões | ✅ |
| Cache de imagens para uso offline | ✅ |

---

## Stack

- **Flutter** 3.x / **Dart** 3.5+
- **BLoC / Cubit** — gerenciamento de estado
- **graphql_flutter** — cliente GraphQL
- **shared_preferences** — persistência local de favoritos e vistos
- **cached_network_image** — cache de imagens (suporte offline)
- **Google Fonts** — tipografia (Space Grotesk · Karla · Space Mono)
- **json_serializable / build_runner** — serialização de modelos
- **equatable** — comparação estrutural de estados

---

## Arquitetura

Clean Architecture por feature, com separação em três camadas:

```text
lib/
├── core/
│   ├── di/               # injeção de dependência via RepositoryProvider
│   ├── errors/           # exceções tipadas
│   ├── graphql/          # queries GraphQL encapsuladas
│   ├── network/          # inicialização do cliente GraphQL
│   ├── theme/            # AppTheme, AppColors, AppTextStyles
│   ├── usecases/         # contrato base UseCase<Type, Params>
│   └── widgets/          # widgets globais (skeletons)
│
└── features/
    ├── episodes/
    │   ├── data/
    │   │   ├── datasources/   # remote (GraphQL) + local (SharedPreferences)
    │   │   ├── models/        # modelos com fromJson/toJson gerados
    │   │   └── repositories/  # implementação do repositório
    │   ├── domain/
    │   │   ├── entities/      # Episode, Character
    │   │   ├── repositories/  # contrato do repositório
    │   │   └── usecases/      # GetEpisodes, ToggleFavorite, ToggleWatched
    │   └── presentation/
    │       ├── cubits/        # EpisodesListCubit + states
    │       ├── pages/         # EpisodesListPage
    │       └── widgets/       # EpisodeCard
    │
    ├── episode_detail/
    │   └── presentation/
    │       ├── cubits/        # EpisodeDetailCubit + states
    │       ├── pages/         # EpisodeDetailPage
    │       └── widgets/       # CharacterCard
    │
    └── favorites_episode/
        └── presentation/
            ├── cubits/        # FavoritesCubit + states
            └── pages/         # FavoritesPage
```

### Decisões de design

- **Cubit sobre Bloc** — estados simples sem distinção de eventos justificam o uso de Cubit, mantendo o código mais enxuto.
- **RepositoryProvider na raiz** — o repositório único é provido na árvore pelo `main.dart`, evitando qualquer singleton global.
- **SharedPreferences para persistência** — favoritos e vistos são armazenados como `Set<String>` de IDs, serializado em JSON. Simples, sem overhead de banco relacional para um dado essencialmente chave-valor.
- **cached_network_image** — as imagens dos personagens ficam em cache em disco após o primeiro carregamento, habilitando visualização offline.
- **Skeleton screens** — enquanto os dados carregam, shimmer placeholders substituem os cards, evitando layout shift.

---

## Pré-requisitos

- Flutter SDK `^3.5.3`
- Dart SDK `^3.5.3`
- Conexão com internet no primeiro acesso (para popular o cache)

## Como rodar

```bash
# instalar dependências
flutter pub get

# gerar código (json_serializable)
dart run build_runner build --delete-conflicting-outputs

# rodar no dispositivo/emulador
flutter run
```

## Gerar código após alteração nos models

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Design System

O app usa tema escuro customizado inspirado na estética da série:

| Token | Cor | Uso |
| --- | --- | --- |
| `portal500` | `#97CE4C` | Ação primária, ícones ativos |
| `cyan400` | `#3FD8E0` | Indicador "visto" |
| `star400` | `#FFD84D` | Favoritos |
| `bgApp` | `#0C1018` | Background principal |
| `surfaceCard` | `#161E2B` | Cards |

Fontes: **Space Grotesk** (títulos), **Karla** (corpo), **Space Mono** (labels/badges).

---

## API

GraphQL endpoint: `https://rickandmortyapi.com/graphql`

Queries utilizadas:

- `episodes(page, filter)` — listagem paginada com filtro por nome
- `episode(id)` — detalhe + lista de personagens
- `episodesByIds(ids)` — busca de múltiplos episódios por ID (tela de favoritos)
