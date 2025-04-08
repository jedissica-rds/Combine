# 📚 Combine Study

Este repositório contém um app de estudo voltado para o aprendizado do **Combine**, o framework de programação reativa da Apple.  
A ideia é explorar seus conceitos-chave aplicando na prática com SwiftUI e arquitetura modularizada.

---

## 🚀 Objetivos

- Entender a arquitetura reativa com Combine
- Criar publishers personalizados
- Utilizar operadores (`map`, `filter`, `merge`, etc.)
- Integrar Combine com chamadas de rede (URLSession)

---

## 🧠 Conceitos abordados

- Encadeamento com operadores (`map`, `flatMap`, `debounce`, etc.)
- Cancelamento de assinaturas (`AnyCancellable`)
- Erros e tratamento (`catch`, `retry`, `sink(receiveCompletion:)`)
- Integração com SwiftUI

---

## 📂 Estrutura do Projeto

```bash
📁 Combine_Study
├── 📁 Combine_Study
│   ├── 📁 Views
│   │   ├── Menu.swift
│   │   ├── Search.swift
│   │   ├── Update.swift
│   │   ├── Operator.swift
│   │   └── Password.swift
│   ├── 📁 Models
│   │   └── Models.swift
│   ├── 📁 Network Layer
│   │   ├── APIEndpoint.swift
│   │   └── EndPoint.swift
│   └── Combine_StudyApp.swift
├── 📁 Assets
├── 📁 Preview Content
