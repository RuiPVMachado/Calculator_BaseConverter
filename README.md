# Calculadora Multi-Base

Uma aplicação moderna em Flutter que suporta múltiplos sistemas de bases numéricas e conversão em tempo real.

## Funcionalidades

### Múltiplos Modos de Base

- **Modo Decimal (Predefinido)**

  - Suporta números de 0-9
  - Operações aritméticas padrão
  - Conversão em tempo real para outras bases

- **Modo Binário**

  - Suporta números 0-1
  - Realiza cálculos em binário
  - Mostra equivalentes em decimal, octal e hexadecimal

- **Modo Octal**

  - Suporta números de 0-7
  - Realiza cálculos em octal
  - Mostra equivalentes em decimal, binário e hexadecimal

- **Modo Hexadecimal**
  - Suporta números de 0-9 e letras A-F
  - Realiza cálculos em hexadecimal
  - Mostra equivalentes em decimal, binário e octal

### Operações da Calculadora

- Operações aritméticas básicas (+, -, ×, ÷)
- Operação de módulo (%)
- Função de limpar (CLEAR)
- Exibição de conversão em tempo real

### Funcionalidades da Interface

- Design Material limpo e moderno
- Botões de mudança de modo no topo
- Ativação/desativação dinâmica de botões baseada no modo atual
- Funcionalidade de copiar para a área de transferência
- Tratamento de erros para operações inválidas (ex: divisão por zero)

## Detalhes Técnicos

### Conversões de Base Numérica

A calculadora fornece conversão em tempo real entre:

- Decimal (Base 10)
- Binário (Base 2)
- Octal (Base 8)
- Hexadecimal (Base 16)

### Validação de Entrada

- Cada modo desativa automaticamente botões de entrada inválidos
- Modo decimal: apenas 0-9 permitidos
- Modo binário: apenas 0-1 permitidos
- Modo octal: apenas 0-7 permitidos
- Modo hexadecimal: 0-9 e A-F permitidos

### Funcionalidades de Exibição

- Mostra a entrada atual na base selecionada
- Exibe histórico de operações
- Mostra conversões em tempo real para todas as outras bases
- Exibição hexadecimal especial mostra valores em hex e decimal

## Implementação

Construído usando Flutter/Dart com:

- Componentes Material Design
- Gestão de estado usando StatefulWidget
- Estilização e layout personalizados dos botões
- Integração com a área de transferência para cópia fácil de valores
- Design responsivo que funciona em vários tamanhos de ecrã

## Utilização

1. Selecione o modo desejado (Decimal, Binário, Octal ou Hexadecimal)
2. Introduza números usando o teclado da calculadora
3. Realize cálculos usando os botões de operação
4. Visualize conversões em tempo real para outras bases numéricas
5. Copie qualquer resultado de conversão tocando nele

## Tratamento de Erros

- Previne entradas inválidas com base no modo selecionado
- Trata divisão por zero com uma mensagem de erro
- Gere graciosamente operações e erros de análise inválidos
