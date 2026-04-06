/// Página de información legal (Política de Privacidad y Términos).
library;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Tipo de documento legal a mostrar.
enum TipoDocumentoLegal { privacidad, terminos }

class LegalPage extends StatelessWidget {
  const LegalPage({required this.tipo, super.key});

  final TipoDocumentoLegal tipo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    final esPrivacidad = tipo == TipoDocumentoLegal.privacidad;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          esPrivacidad ? l.authPrivacyPolicy : l.authTermsAndConditions,
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              esPrivacidad ? l.authPrivacyPolicy : l.authTermsAndConditions,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.legalLastUpdated,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            if (esPrivacidad)
              ..._buildPrivacyContent(theme, l)
            else
              ..._buildTermsContent(theme, l),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPrivacyContent(ThemeData theme, S l) {
    return [
      _Section(
        theme: theme,
        title: l.legalPrivacy1Title,
        body: l.legalPrivacy1Body,
      ),
      _Section(
        theme: theme,
        title: l.legalPrivacy2Title,
        body: l.legalPrivacy2Body,
      ),
      _Section(
        theme: theme,
        title: l.legalPrivacy3Title,
        body: l.legalPrivacy3Body,
      ),
      _Section(
        theme: theme,
        title: l.legalPrivacy4Title,
        body: l.legalPrivacy4Body,
      ),
      _Section(
        theme: theme,
        title: l.legalPrivacy5Title,
        body: l.legalPrivacy5Body,
      ),
      _Section(
        theme: theme,
        title: l.legalPrivacy6Title,
        body: l.legalPrivacy6Body,
      ),
      _Section(
        theme: theme,
        title: l.legalPrivacy7Title,
        body: l.legalPrivacy7Body,
      ),
    ];
  }

  List<Widget> _buildTermsContent(ThemeData theme, S l) {
    return [
      _Section(
        theme: theme,
        title: l.legalTerms1Title,
        body: l.legalTerms1Body,
      ),
      _Section(
        theme: theme,
        title: l.legalTerms2Title,
        body: l.legalTerms2Body,
      ),
      _Section(
        theme: theme,
        title: l.legalTerms3Title,
        body: l.legalTerms3Body,
      ),
      _Section(
        theme: theme,
        title: l.legalTerms4Title,
        body: l.legalTerms4Body,
      ),
      _Section(
        theme: theme,
        title: l.legalTerms5Title,
        body: l.legalTerms5Body,
      ),
      _Section(
        theme: theme,
        title: l.legalTerms6Title,
        body: l.legalTerms6Body,
      ),
    ];
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.theme,
    required this.title,
    required this.body,
  });

  final ThemeData theme;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
