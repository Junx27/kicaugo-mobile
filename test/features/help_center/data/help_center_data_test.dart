import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/help_center/data/datasources/fake_help_center_data_source.dart';
import 'package:rumahkicau_mobile/features/help_center/data/repositories/help_center_repository_impl.dart';
import 'package:rumahkicau_mobile/features/help_center/domain/entities/help_center_content.dart';
import 'package:rumahkicau_mobile/features/help_center/domain/usecases/get_help_center_content.dart';

import '../help_center_fakes.dart';

void main() {
  test('fake data source mengembalikan konten bantuan lengkap', () async {
    const dataSource = FakeHelpCenterDataSource(delay: Duration.zero);
    final content = await dataSource.fetchHelpCenterContent();

    expect(content, same(FakeHelpCenterDataSource.content));
    expect(content.event.title, 'Piala Raja Nusantara 2025 (PBI)');
    expect(content.quickActions, hasLength(4));
    expect(content.contacts, hasLength(3));
    expect(content.faqs, hasLength(4));
    expect(content.faqs.last.id, 'offline');
  });

  test('fake data source menunggu delay sebelum mengembalikan data', () async {
    const dataSource = FakeHelpCenterDataSource(
      delay: Duration(milliseconds: 1),
    );
    final content = await dataSource.fetchHelpCenterContent();

    expect(content.event.venue, 'Batavia Arena Gantangan, Jakarta Timur');
  });

  test('repository meneruskan konten dari data source', () async {
    const repository = HelpCenterRepositoryImpl(
      FakeHelpCenterDataSource(delay: Duration.zero),
    );

    final content = await repository.fetchHelpCenterContent();

    expect(content.contacts.last.name, 'Sekretariat EO Batavia Arena');
  });

  test('usecase memanggil repository', () async {
    final repository = FakeHelpCenterRepository();
    final content = await GetHelpCenterContent(repository)();

    expect(repository.fetchCalls, 1);
    expect(content, same(sampleHelpCenter));
  });

  test('entity membandingkan seluruh properti', () {
    final event = sampleHelpCenter.event;
    final action = sampleHelpCenter.quickActions.first;
    final contact = sampleHelpCenter.contacts.first;
    final faq = sampleHelpCenter.faqs.first;

    expect(
      event,
      HelpEventInfo(
        title: event.title,
        venue: event.venue,
        fieldHours: event.fieldHours,
        registrationLabel: event.registrationLabel,
      ),
    );
    expect(
      action,
      HelpQuickAction(
        id: action.id,
        kind: action.kind,
        title: action.title,
        description: action.description,
        badge: action.badge,
        ctaLabel: action.ctaLabel,
      ),
    );
    expect(
      contact,
      HelpContact(
        id: contact.id,
        kind: contact.kind,
        name: contact.name,
        role: contact.role,
        actionLabel: contact.actionLabel,
      ),
    );
    expect(
      faq,
      HelpFaq(id: faq.id, question: faq.question, answer: faq.answer),
    );
    expect(
      sampleHelpCenter,
      HelpCenterContent(
        event: event,
        quickActions: sampleHelpCenter.quickActions,
        contacts: sampleHelpCenter.contacts,
        faqs: sampleHelpCenter.faqs,
      ),
    );
  });
}
